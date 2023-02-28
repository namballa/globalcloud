from pyspark import SparkContext
from pyspark import SparkConf
import findspark
findspark.init()

import pyspark
from pyspark.sql import SparkSession
spark = SparkSession.builder.master("local[1]").appName("Gloabal Cloud by Hari").getOrCreate()

df=spark.read.format("csv").option("header","true").load("1.csv,2.csv")
df.show()
# sc = SparkContext("local", "count app")
# words = sc.parallelize (
#    ["scala", 
#    "java", 
#    "hadoop", 
#    "spark", 
#    "akka",
#    "spark vs hadoop", 
#    "pyspark",
#    "pyspark and spark"]
# )
# counts = words.count()
# print ("Number of elements in RDD -> %i" % (counts))