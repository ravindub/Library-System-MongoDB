<%@page import="java.text.DateFormat,java.text.SimpleDateFormat,java.util.Date" 
		import="com.mongodb.client.*,org.bson.Document" 
		import= "static com.mongodb.client.model.Filters.*"
		import= "static com.mongodb.client.model.Updates.*"
		import= "org.bson.types.ObjectId"
		import="com.library.db.dbConnect"%>
<%!
	public static String getDate()
    
	{
        
		DateFormat df=new SimpleDateFormat("yyyy-MM-dd");
        
		String exam_date=df.format(new Date());
         
		return exam_date;
    
	}
%>
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
	String bookid=request.getParameter("bookid");
	String update=request.getParameter("update");
	
	MongoCollection<Document> collection = db.getCollection("books");
	Document myDoc = collection.find(eq("_id", new ObjectId(bookid))).first();
	
	if(update!=null)
	{
		String bookname=request.getParameter("bookname");		
		String category=request.getParameter("category");
		String author=request.getParameter("author");
		String isbn=request.getParameter("isbn");
		String price=request.getParameter("price");
		String updateDate = getDate();
		
		collection.updateOne(
                eq("_id", new ObjectId(bookid)),
                combine(set("bookname", bookname), 
                		set("category", category), 
                		set("author", author), 
                		set("isbn", isbn), 
                		set("price", price),
                		set("UpdationDate", updateDate) ));
		
		session.setAttribute("msg","Book Info updated successfully");
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
    <title>Vision Library | Edit Book</title>
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
<input class="form-control" type="text" name="bookname" value="<%=(String) myDoc.get("bookname")%>" required />
</div>

<div class="form-group">
<label> Category<span style="color:red;">*</span></label>
<select class="form-control" name="category" required="required">
<option value="<%=(String) myDoc.get("category")%>"> <%= (String) myDoc.get("category") %></option>
<% 
MongoCollection<Document> collectionCat = db.getCollection("categories");
MongoCursor<Document> cursor = collectionCat.find().iterator();

String selecCat = (String) myDoc.get("category");

	while(cursor.hasNext())
	{
		Document myDoc1 = cursor.next();
        String ct = (String) myDoc1.get("category");
        
		if(selecCat.equalsIgnoreCase(ct)){
			continue;
		}
		else{
  %>  
<option value="<%=ct%>"><%=ct%></option>
 <% }} cursor.close(); %> 
</select>
</div>


<div class="form-group">
<label> Author<span style="color:red;">*</span></label>
<select class="form-control" name="author" required="required">
<option value="<%=(String) myDoc.get("author")%>"> <%=(String) myDoc.get("author")%></option>
<% 

MongoCollection<Document> collectionAut = db.getCollection("authors");
MongoCursor<Document> cursor2 = collectionAut.find().iterator();
String selectAut = (String) myDoc.get("author");

while(cursor2.hasNext())
{
	Document myDoc2 = cursor2.next();
	String aut = (String) myDoc2.get("author");
	if(selectAut.equalsIgnoreCase(aut)){
		continue;
	}else{
    %>  
<option value="<%=aut%>"><%=aut%></option>
 <% }} cursor2.close(); %> 
</select>
</div>

<div class="form-group">
<label>ISBN Number<span style="color:red;">*</span></label>
<input class="form-control" type="number" name="isbn" value="<%=(String) myDoc.get("isbn")%>"  required="required" />
<p class="help-block">An ISBN is an International Standard Book Number.ISBN Must be unique</p>
</div>

 <div class="form-group">
 <label>Price in LKR<span style="color:red;">*</span></label>
 <input class="form-control" type="text" name="price" value="<%=(String) myDoc.get("price")%>"   required="required" />
 </div>
 
<button type="submit" name="update" class="btn btn-info">Update </button>

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
<% } %>
