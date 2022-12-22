<%@page import="java.text.DateFormat,java.text.SimpleDateFormat,java.util.Date" 
		import="com.mongodb.client.*,org.bson.Document" 
		import= "static com.mongodb.client.model.Filters.*"
		import= "static com.mongodb.client.model.Updates.*"
		import="com.library.db.dbConnect"%>
<%@page errorPage="error.jsp"%>
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
String email=(String)session.getAttribute("login");
if(email==null)
{   
	response.sendRedirect("index.jsp");
}
else
{ 
	String sid=(String)session.getAttribute("stdid");
	String updateValue=request.getParameter("update");
	
	MongoCollection<Document> collection = db.getCollection("students");
	Document myDoc = collection.find(eq("studentID", sid)).first();
	
	if(updateValue!=null && updateValue.equals("update"))
	{    
		
		String fname=request.getParameter("fullanme");
		String mobileno=request.getParameter("mobileno");

		collection.updateOne(
                eq("studentID",sid),
                combine(set("fullName", fname), set("mobile", mobileno)));
		

			out.println("<script>alert('Your profile has been updated')</script>");
			out.println("<script type='text/javascript'> document.location ='my-profile.jsp'; </script>");
	}	

%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <!--[if IE]>
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <![endif]-->
    <title>ABC Library | Student Sign up</title>
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
                <h4 class="header-line">My Profile</h4>
                
                            </div>

        </div>
             <div class="row">
           
<div class="col-md-9 col-md-offset-1">
               <div class="panel panel-danger">
                        <div class="panel-heading">
                           My Profile
                        </div>
                        <div class="panel-body">
                            <form name="signup" method="post">

	<div class="form-group">
	<label>Student ID : </label>
	<%=(String) myDoc.get("studentID")%>
	</div>



	<div class="form-group">
	<label>Enter Full Name</label>
	<input class="form-control" type="text" name="fullanme" value="<%=(String) myDoc.get("fullName")%>" autocomplete="off" required />
	</div>


	<div class="form-group">
	<label>Mobile Number :</label>
	<input class="form-control" type="text" name="mobileno" maxlength="10" value="<%=(String) myDoc.get("mobile")%>" autocomplete="off" required />
	</div>
                                        
	<div class="form-group">
	<label>Enter Email</label>
	<input class="form-control" type="email" name="email" id="emailid" value="<%=(String) myDoc.get("email")%>"  autocomplete="off" required readonly />
	</div>

                         
<button type="submit" name="update" value="update" class="btn btn-primary" id="submit">Update Now </button>

                                    </form>
                            </div>
                        </div>
                            </div>
        </div>
    </div>
    </div>
     <!-- CONTENT-WRAPPER SECTION END-->
	<jsp:include page="includes/footer.jsp" />
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
