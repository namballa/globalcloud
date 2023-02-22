// Databricks notebook source
val appID ="8c4e1b4b-f39b-47c4-a79b-a155da40d479"
val secret ="Lb8[Tdrf%0?{2#n3"
val tenantID ="e3bbde79-25a2-462f-8e11-88f297ee81c4"

spark.conf.set("fs.azure.account.auth.type", "OAuth")
spark.conf.set("fs.azure.account.oauth.provider.type", "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider")
spark.conf.set("fs.azure.account.oauth2.client.id", "<appID>")
spark.conf.set("fs.azure.account.oauth2.client.secret", "<secret>")
spark.conf.set("fs.azure.account.oauth2.client.endpoint", "https://login.microsoftonline.com/<tenant-id>/oauth2/token")
spark.conf.set("fs.azure.createRemoteFileSystemDuringInitialization", "true")

// COMMAND ----------

val storageAccountName ="saauedevsingheradevops"
val appID ="8c4e1b4b-f39b-47c4-a79b-a155da40d479"
val secret ="Lb8[Tdrf%0?{2#n3"
val fileSystemName ="saauedevsingheradevops"
val tenantID ="e3bbde79-25a2-462f-8e11-88f297ee81c4"

spark.conf.set("fs.azure.account.auth.type." + storageAccountName + ".dfs.core.windows.net", "OAuth")
spark.conf.set("fs.azure.account.oauth.provider.type." + storageAccountName + ".dfs.core.windows.net", "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider")
spark.conf.set("fs.azure.account.oauth2.client.id." + storageAccountName + ".dfs.core.windows.net", "" + appID + "")
spark.conf.set("fs.azure.account.oauth2.client.secret." + storageAccountName + ".dfs.core.windows.net", "" + secret + "")
spark.conf.set("fs.azure.account.oauth2.client.endpoint." + storageAccountName + ".dfs.core.windows.net", "https://login.microsoftonline.com/" + tenantID + "/oauth2/token")
spark.conf.set("fs.azure.createRemoteFileSystemDuringInitialization", "true")
dbutils.fs.ls("abfss://" + fileSystemName  + "@" + storageAccountName + ".dfs.core.windows.net/")
spark.conf.set("fs.azure.createRemoteFileSystemDuringInitialization", "false")

// COMMAND ----------

// MAGIC %sh wget -P /tmp https://raw.githubusercontent.com/Azure/usql/master/Examples/Samples/Data/json/radiowebsite/small_radio_json.json

// COMMAND ----------

// MAGIC %python
// MAGIC fileSystemName ="saauedevsingheradevops"
// MAGIC storageAccountName ="saauedevsingheradevops"
// MAGIC dbutils.fs.cp("file:///tmp/small_radio_json.json", "abfss://" + fileSystemName + "@" + storageAccountName + ".dfs.core.windows.net/")

// COMMAND ----------

val df = spark.read.json("abfss://" + fileSystemName + "@" + storageAccountName + ".dfs.core.windows.net/small_radio_json.json")
df.show()

// COMMAND ----------

val specificColumnsDf = df.select("firstname", "lastname", "gender", "location", "level")
specificColumnsDf.show()

// COMMAND ----------

val renamedColumnsDF = specificColumnsDf.withColumnRenamed("level", "subscription_type")
renamedColumnsDF.show()

// COMMAND ----------

//Azure Synapse related settings
val blobStorage ="saauedevsingheradevopsblobcorewindowsnet"
val blobContainer ="fsauedevsingheradevops"
val blobAccessKey ="9exos5ljyWNYvgJPiQvyFb6e0GAJFz1VypFU04RV7YFKTQUoafucBVecfCwqXbPbSrGzoXYUaAStZRBddQ"
val tempDir = "wasbs://" + blobContainer + "@" + blobStorage +"/tempDirs"
val acntInfo = "fs.azure.account.key."+ blobStorage
sc.hadoopConfiguration.set(acntInfo, blobAccessKey)
val dwDatabase ="pool_singheradevops"
val dwServer = "ws-aue-dev-glbcld.sql.azuresynapse.net"
val dwUser ="sqladmin"
val dwPass ="2ytIvKIDyD1G9LSf"
val dwJdbcPort =  "1433"
val dwJdbcExtraOptions = "encrypt=true;trustServerCertificate=true;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"
val sqlDwUrl = "jdbc:sqlserver://" + dwServer + ":" + dwJdbcPort + ";database=" + dwDatabase + ";user=" + dwUser+";password=" + dwPass + ";$dwJdbcExtraOptions"
val sqlDwUrlSmall = "jdbc:sqlserver://" + dwServer + ":" + dwJdbcPort + ";database=" + dwDatabase + ";user=" + dwUser+";password=" + dwPass

spark.conf.set(
    "spark.sql.parquet.writeLegacyFormat",
    "true")

renamedColumnsDF.write.format("com.databricks.spark.sqldw")
.option("url", sqlDwUrlSmall)
.option("dbtable", "SampleTable")
.option( "forward_spark_azure_storage_credentials","True")
.option("tempdir", tempDir)
.mode("overwrite")
.save()
