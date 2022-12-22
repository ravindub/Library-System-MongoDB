package com.library.db;
import com.mongodb.client.*;

  public class dbConnect {
	
	 static MongoDatabase database = null;
	 
	   public static MongoDatabase getDatabase() {
	      if (database != null) {
	    	  return database;
	      }
	      else {
		      
	    	  String dbname = "Mylibrary";
		      return getDatabase(dbname);
	      }
	   }
	   
		   
	   private static MongoDatabase getDatabase(String databaseName) {
		  
		   try {
			   	MongoClient mongoClient = MongoClients.create();
			   	database = mongoClient.getDatabase(databaseName);
			   	System.out.println("New Db connection");
		  }catch (Exception e) {
		         e.printStackTrace();
		  }
		  return database;
		  }
		
	   
}

