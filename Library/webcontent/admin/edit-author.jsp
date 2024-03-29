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
	String athrid=request.getParameter("athrid");
	String update=request.getParameter("update");
	
	
	MongoCollection<Document> collection = db.getCollection("authors");
	Document myDoc = collection.find(eq("_id", new ObjectId(athrid))).first();
	

	if(update!=null)
	{
		String updateDate = getDate();
		
		String author=request.getParameter("author");
		
		collection.updateOne(
                eq("_id", new ObjectId(athrid)),
                combine(set("author", author), set("UpdationDate", updateDate)));

		session.setAttribute("updatemsg","Author info updated successfully");
		response.sendRedirect("manage-authors.jsp");
}
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>ABC Library | Add Author</title>
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
                <h4 class="header-line">Add Author</h4>
                
                            </div>

</div>
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
<div class="panel panel-info">
<div class="panel-heading">
Author Info
</div>
<div class="panel-body">
<form role="form" method="post">
<div class="form-group">
<label>Author Name</label>
   
<input class="form-control" type="text" name="author" value="<%=(String) myDoc.get("author")%>" required />



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