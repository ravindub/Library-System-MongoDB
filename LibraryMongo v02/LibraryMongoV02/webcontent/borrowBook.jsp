<%@page import="java.text.DateFormat,java.text.SimpleDateFormat,java.util.Date,java.time.LocalDate"
	import="com.mongodb.client.*,org.bson.Document" 
	import= "static com.mongodb.client.model.Filters.*"
	import= "static com.mongodb.client.model.Updates.*"
	import= "org.bson.types.ObjectId"
	 import="com.library.db.dbConnect" %>
<%!
	
%>
<%
	MongoDatabase db = dbConnect.getDatabase();	
        
       
        
%>

<%

String studentid=(String)session.getAttribute("stdid");

if(session.getAttribute("login")==null)
{ 
	response.sendRedirect("index.jsp");
}
else
{ 
	LocalDate date = LocalDate.now();
	String issue=request.getParameter("issue");
	if(issue!=null)
	{
		String bookName=request.getParameter("bookname");
		MongoCollection<Document> collectionBooks = db.getCollection("books");
		Document book = collectionBooks.find(eq("_id",new ObjectId(bookName))).first();
		
		MongoCollection<Document> collectionStd = db.getCollection("students");
		Document student = collectionStd.find(eq("studentID",studentid )).first();
		
		if(studentid != null)
		{
			
			MongoCollection<Document> collectionbk = db.getCollection("issuedbooks");
			
			Document doc = new Document("bookID",book)
		            .append("studentID", student)
		            .append("issuedDate",date);
			
			collectionbk.insertOne(doc);
			
			session.setAttribute("msg","Book issued successfully");
			response.sendRedirect("issued-books.jsp");
			
			
		}	
		
	}

%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>Vision Library | Borrow a new Book</title>
    <!-- BOOTSTRAP CORE STYLE  -->
    <link href="assets/css/bootstrap.css" rel="stylesheet" />
    <!-- FONT AWESOME STYLE  -->
    <link href="assets/css/font-awesome.css" rel="stylesheet" />
    <!-- CUSTOM STYLE  -->
    <link href="assets/css/style.css" rel="stylesheet" />
    <!-- GOOGLE FONT -->
    <link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css' />

<style type="text/css">
  .others{
    color:red;
}

</style>


</head>
<body>
      <!------MENU SECTION START-->
<jsp:include page="includes/header.jsp" />
<!-- MENU SECTION END-->
    
    <div class="content-wrapper">
         <div class="container">
        <div class="row pad-botm">
            <div class="col-md-12">
                <h4 class="header-line">Borrow a New Book</h4>
                
                            </div>

</div>
<div class="row">
<div class="col-md-10 col-sm-6 col-xs-12 col-md-offset-1">
<div class="panel panel-info">
<div class="panel-heading">
Borrow a New Book
</div>
<div class="panel-body">
<form role="form" method="post">

<div class="form-group">
<label>Select a Book<span style="color:red;">*</span></label>
<select class="form-control" name="bookname"  required>
<%

MongoCollection<Document> collectionBook = db.getCollection("books");
MongoCursor<Document> cursor = collectionBook.find().iterator();


while(cursor.hasNext())
{
	Document myDoc = cursor.next();
%>
<option value="<%=myDoc.get("_id") %>"><%=myDoc.get("bookname") %></option>
<%
}cursor.close();


%>
</select>
</div>

<button type="submit" name="issue" value="issue" id="submit" class="btn btn-info">Borrow Book</button>

  </form>
     </div>
           </div>
                  </div>

        
   
    </div>
    </div>
    </div>
     <!-- CONTENT-WRAPPER SECTION END-->
<jsp:include page="includes/footer.jsp" />
      <!-- FOOTER SECTION END-->
    <!-- JAVASCRIPT FILES PLACED AT THE BOTTOM TO REDUCE THE LOADING TIME  -->
    <!-- CORE JQUERY  -->
    <script src="assets/js/jquery-1.10.2.js"></script>
    <!-- BOOTSTRAP SCRIPTS  -->
    <script src="assets/js/bootstrap.js"></script>
      <!-- CUSTOM SCRIPTS  -->
    <script src="assets/js/custom.js"></script>

</body>
</html>
<%
 } 
%>
