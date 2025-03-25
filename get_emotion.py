import pandas as pd
from sqlalchemy import create_engine
import nltk
import text2emotion as te

# PostgreSQL database connection URL
DATABASE_URL = "postgresql://ytscraper:scrapemall@localhost:5432/youtube_comments_db"

try:
    engine = create_engine (DATABASE_URL)
    with engine.connect() as conn:
        comments_df = pd.read_sql_query("SELECT * FROM comments;",conn)
        print("Connected successfully to Database")
except Exception as e:
    print(f"Problem with DB connection {e}")

# Create a function that get the dominant emotion
def get_dominant_emotion(comment):
    emotions = te.get_emotion(comment)
    return max(emotions,key=emotions.get)

comments_df['dominant_emotion'] = comments_df.comment.apply(get_dominant_emotion)

"""Save the DataFrame to a PostgreSQL database."""
try:
    engine = create_engine(DATABASE_URL)
    with engine.connect() as conn:
        comments_df.to_sql("comments", con=conn, if_exists="replace",index=False) #index=True, index_label='id')
    print("Data successfully inserted into PostgreSQL!")
except Exception as e:
    print(f"Database insertion failed: {e}")