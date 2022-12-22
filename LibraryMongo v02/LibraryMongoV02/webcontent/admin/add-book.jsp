<%@page 
	import="com.mongodb.client.*,org.bson.Document" 
	import= "static com.mongodb.client.model.Filters.*"
	import= "static com.mongodb.client.model.Updates.*"
	import="com.library.db.dbConnect"%>
<%
	MongoDatabase db = dbConnect.getDatabase();	
       
%>

<%

if(session.getAttribute("alogin")==null)
{ 
	response.sendRedirect("../index.jsp");
}
else
{ 
	String add=request.getParameter("add");
if(add!=null)
{
	String bookname=request.getParameter("bookname");
	String category=request.getParameter("category");
	String author=request.getParameter("author");
	String isbn=request.getParameter("isbn");
	String price=request.getParameter("price");
	
	MongoCollection<Document> collection = db.getCollection("books");
	
	Document doc = new Document("bookname",bookname  )
            .append("category", category)
            .append("author",author )
            .append("isbn", isbn)
            .append("price",price);
	
	collection.insertOne(doc);
	
	session.setAttribute("msg","Book Listed successfully");
	response.sendRedirect("manage-books.jsp");	
	
}
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>Vision Library | Add Book</title>
    <!-- BOOTSTRAP CORE STYLE  -->
    <link href="assets/css/bootstrap.css" rel="stylesheet" />
    <!-- FONT AWESOME STYLE  -->
    <link href="assets/css/font-awesome.css" rel="stylesheet" />
    <!-- CUSTOM STYLE  -->
    <link href="assets/css/style.css" rel="stylesheet" />
    <!-- GOOGLE FONT -->
    <link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css' />

</head>
<body>
      <!------MENU SECTION START-->
<jsp:include page="includes/header.jsp" />
<!-- MENU SECTION END-->
   
    <div class="content-wrapper">
         <div class="container">
        <div class="row pad-botm">
            <div class="col-md-12">
                <h4 class="header-line">Add Book</h4>
                
                            </div>

</div>
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
<div class="panel panel-info">
<div class="panel-heading">
Book Info
</div>
<div class="panel-body">
<form role="form" method="post">
<div class="form-group">
<label>Book Name<span style="color:red;">*</span></label>
<input class="form-control" type="text" name="bookname" autocomplete="off"  required />
</div>

<div class="form-group">
<label> Category<span style="color:red;">*</span></label>
<select class="form-control" name="category" required="required">
<option value=""> Select Category</option>
<% 

MongoCollection<Document> collectionCat = db.getCollection("categories");
MongoCursor<Document> cursor = collectionCat.find().iterator();

int cnt=1;

while(cursor.hasNext())
{
	Document myDoc = cursor.next();
%>  
<option value="<%=myDoc.get("category")%>"><%=myDoc.get("category")%></option>
<% 
} cursor.close();
%> 
</select>
</div>


<div class="form-group">
<label> Author<span style="color:red;">*</span></label>
<select class="form-control" name="author" required="required">
<option value=""> Select Author</option>
<% 

MongoCollection<Document> collectionAut = db.getCollection("authors");
MongoCursor<Document> cursor2 = collectionAut.find().iterator();

cnt=1;
while(cursor2.hasNext())
{
	Document myDoc2 = cursor2.next();
%>  
<option value="<%=myDoc2.get("author")%>"><%=myDoc2.get("author")%></option>
 <%
 } cursor2.close();

%> 
</select>
</div>

<div class="form-group">
<label>ISBN Number<span style="color:red;">*</span></label>
<input class="form-control" type="number" name="isbn"  required="required" autocomplete="off"  />
<p class="help-block">An ISBN is an International Standard Book Number.ISBN Must be unique</p>
</div>

 <div class="form-group">
 <label>Price<span style="color:red;">*</span></label>
 <input class="form-control" type="text" name="price" autocomplete="off"   required="required" />
 </div>
<button type="submit" name="add" value="add" class="btn btn-info">Add </button>

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
