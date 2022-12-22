<%@page import="java.text.DateFormat,java.text.SimpleDateFormat,java.util.Date,java.time.LocalDate"
	import="com.mongodb.client.*,org.bson.Document" 
	import="org.bson.*"
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

if(session.getAttribute("login")==null)
{ 
	response.sendRedirect("index.jsp");
}
else
{ 
	String rid = request.getParameter("rid");
	LocalDate retdate = LocalDate.now();
	String ret=request.getParameter("return");
	
	MongoCollection<Document> collectionBook = db.getCollection("issuedbooks");
	
	
	if(ret!=null)
	{
		
		int fine=Integer.parseInt(request.getParameter("fine"));
		
		collectionBook.updateOne(
                eq("_id", new ObjectId(rid)),
                combine(set("fine", fine), 
                		set("returnedDate", retdate) ));
		
		session.setAttribute("msg","Book Returned successfully");
		response.sendRedirect("issued-books.jsp");
		

	}
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>Vision Library | Issued Book Details</title>
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
                <h4 class="header-line">Issued Book Details</h4>
                
                            </div>

</div>
<div class="row">
<div class="col-md-10 col-sm-6 col-xs-12 col-md-offset-1">
<div class="panel panel-info">
<div class="panel-heading">
Issued Book Details
</div>
<div class="panel-body">
<form role="form" method="post">
<%
	String sid=(String)session.getAttribute("stdid");
	
	FindIterable<Document> findIterable = collectionBook.find(eq("_id",new ObjectId(rid)));

	MongoCursor<Document> cursor = findIterable.iterator();
	
	int cnt=1;
	while(cursor.hasNext())
	{
		
		Document myDoc = cursor.next();
		Document myDoc2 = myDoc.get("bookID", Document.class);
		Document myDoc3 = myDoc.get("studentID", Document.class);
		//System.out.println(myDoc3);
		
		Date date = myDoc.getDate("issuedDate");
		Date returndate = myDoc.getDate("returnedDate");
		SimpleDateFormat DateFor = new SimpleDateFormat("yyyy-MM-dd");
		String stringDate= DateFor.format(date);
		
%>                                      
                   



<div class="form-group">
<label>Student Name :</label>
<%=myDoc3.get("fullName")%>
</div>

<div class="form-group">
<label>Book Name :</label>
<%=myDoc2.get("bookname")%>
</div>


<div class="form-group">
<label>ISBN :</label>
<%=myDoc2.get("isbn")%>
</div>

<div class="form-group">
<label>Book Issued Date :</label>
<%=stringDate%>
</div>


<div class="form-group">
<label>Book Returned Date :</label>
<% if(myDoc.get("returnedDate")==null)
                                            {
                                                out.println("Not Return Yet");
                                            } else {

                                            String stringRetDate= DateFor.format(returndate);
                                            out.println(stringRetDate);
}
                                            %>
</div>

<div class="form-group">
<label>Fine (in LKR) :</label>
<% 
if(myDoc.get("fine")==null)
{%>
<input class="form-control" type="number" name="fine" id="fine"  required />

<% }else {
	out.println(myDoc.get("fine"));
}
%>
</div>
 <% if(myDoc.get("returnedDate")== null){%>

<button type="submit" name="return" id="submit" class="btn btn-info">Return Book </button>
</form>

<% }
 }
	cursor.close();
	
%>
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
