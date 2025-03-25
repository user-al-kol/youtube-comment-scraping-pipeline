## Youtube Comment Scraping Pipeline

This is a ELT data pipeline that scraps comments from any Youtube video (up to 90, by default), stores them in a PostgreSQL database that runs in a docker container and then analyses their emotional content and stores each comment's emotions under a new column in the database.

### How to use

1) **Virtual Environment**
The best way of usage is to create a Python virtual environment and install by using pip the modules in requirements.txt. In case you don't create a virtual environment you need to install the requirements and change the bash (.sh)(code blocks in lines 14 and 38) or powershell (.ps1)(code blocks in lines 13 and 40) files. 

2) **Scraper**
In the scraper script (youtube_comment_scraper.py) there is a section that deals with pop-up menus. In my case I faced some problems with pop-up menus and thus this part of the code was developed. You can adjust it according to your needs, change it, delete it or comment it out.

In the same script you can go to the main function and insert the URL of the Youtube video whose comments you want to scrape. In the scrape_youtube_comments function you will find the argument max_comments which is set to 90. You can change it according to your needs. If you need less than 90 comments, no changes are required. If you exceed this number, maybe you'll need to adjust the code in the code block on line 46 or find another solution peculiar to your situation.

3) **Automation**
For Linux environment users I have made a bash script that runs the entire pipeline. For Windows users I've made a PowerShell script that does the same. The scripts can be used in combination with CronJob or Task Scheduler.
     
