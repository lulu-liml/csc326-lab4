Some general background information:

url.text:
it contains three urls:
1.https://www.utoronto.ca/
2.https://www.utoronto.ca/donors
3.http://www.eecg.toronto.edu/ (as required for AWS Deployment)

crawler.py:
1.depth is set to 1.
2.You need to have redis server running before run python crawler.py.

how data is stored in and fetched out of the redis db:
1. Since redis db store all data into string, so we decide to use json to convert all json readable dict to json string
2. When we fetch out the stored data from db, we convert them back to dict from json string.


Backend:
1. Run run_backend_test.py file and it will - run crawler.py
											- run pagerank.py
											- run pprint to print readable_page_rank
* if you want, there are some commented out codes for redis db set up which you can add them back so that you do not have to separately run crawler.py anymore, however, make sure you always have redis server running before performing any db changes. (It is unnecessary to do so if you want to use server.py to populate data).

2. To run server.py locally, first you need to run crawler.py to have crawled data stored in redis db, then run python server.py.

3. How to access our frontend on AWS: 
   Public DNS: http://54.198.180.246/
   
4. Frontend benchmark setup and results:
   