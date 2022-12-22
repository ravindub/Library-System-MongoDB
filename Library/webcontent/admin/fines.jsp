<%@page 
	import="com.mongodb.client.*,org.bson.Document" 
	import="org.bson.*,java.util.Date,java.text.SimpleDateFormat"
	import= "static com.mongodb.client.model.Filters.*"
	import= "static com.mongodb.client.model.Updates.*"
	import= "org.bson.types.ObjectId,com.mongodb.client.model.Aggregates,com.mongodb.client.model.Accumulators,java.util.Arrays"
 	import="com.library.db.dbConnect"%>
<%
	MongoDatabase db = dbConnect.getDatabase();	
	int sum = 0 ;
       
%>

<%

if(session.getAttribute("alogin")==null)
{ 
	response.sendRedirect("../index.jsp");
}
else
{
	
	
	MongoCollection<Document> collection = db.getCollection("students");
	 MongoCursor<Document> cursor = collection.find().iterator();
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>ABC Library | Fines</title>
    <!-- BOOTSTRAP CORE STYLE  -->
    <link href="assets/css/bootstrap.css" rel="stylesheet" />
    <!-- FONT AWESOME STYLE  -->
    <link href="assets/css/font-awesome.css" rel="stylesheet" />
    <!-- DATATABLE STYLE  -->
    <link href="assets/js/dataTables/dataTables.bootstrap.css" rel="stylesheet" />
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
                <h4 class="header-line">Total Fine paid by the Student</h4>
    </div>



        </div>
        <div class="row">
<div class="col-md-12">
<div class="panel panel-info">
<div class="panel-heading">
	Select Student and Duration
</div>
<div class="panel-body">
<form role="form" method="post">

<div class="form-group">
<label>Select Student<span style="color:red;">*</span></label>
<select class="form-control" name="stdname"  required>
<%

while(cursor.hasNext())
{
	Document myDoc = cursor.next();
	
	String sname = myDoc.get("fullName",String.class);
	String sid = myDoc.get("studentID",String.class); 
%>
<option value="<%=sid %>"><%=sname %></option>
<%
}


%>
</select>
</div>


<div class="form-group">
<label>From<span style="color:red;">*</span></label>
<input class="form-control" type="date" id="from" name="from" min="1900-01-01" max="2200-01-01" required>
</div>

<div class="form-group">
<label>To<span style="color:red;">*</span></label>
<input class="form-control" type="date" id="to" name="to" min="1900-01-01" max="2200-01-01" required>
</div>

<button type="submit" name="genReport" value="genReport" id="submit" class="btn btn-info">Generate Report </button>

                                    </form>
                            </div>
                        </div>
                            </div>

        </div>
        
    <%
        String sid=request.getParameter("stdname");
    	String from=request.getParameter("from");
    	String to=request.getParameter("to");
    	
		SimpleDateFormat sdt = new SimpleDateFormat("yyyy-MM-dd");
        
    	MongoCollection<Document> collectionBooks = db.getCollection("issuedbooks");

    	if(from != null && to != null){
    		Date fromDate = sdt.parse(from);
            Date toDate = sdt.parse(to);
        	
            
            FindIterable<Document> findIterable = collectionBooks.find(and(gte("issuedDate", fromDate), lte("issuedDate", toDate),eq("studentID.studentID",sid)));
        	
            FindIterable<Document> sumiter = collectionBooks.find(and(gte("issuedDate", fromDate), lte("issuedDate", toDate),eq("studentID.studentID",sid)));
       
            
            MongoCursor<Document> fineSum = sumiter.iterator();
            while(fineSum.hasNext()){
            	Document d = fineSum.next();
            	if(d.get("fine") != null){
            		sum = (int)d.get("fine") + sum;
            		
            	
            	}
            } fineSum.close();
           
			
            
            
        	MongoCursor<Document> cursorbook = findIterable.iterator();
    	
        
        
     %>
            <div class="row">
                <div class="col-md-12">
                    <!-- Advanced Tables -->
                    <div class="panel panel-default">
                        <div class="panel-heading">
                          Total Fine
                        </div>
                        <div class="panel-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered table-hover" id="dataTables-example">
                                    <thead>
                                        <tr>
                                            <th>Student ID</th>
                                            <th>Student Name </th>
                                            <th>Email</th>
                                            <th>Mobile Number</th>
                                            <th>Total Fine(LKR)</th>
                                        </tr>
                                    </thead>
                                    <tbody>
<%
	
		
		
		
		
	

if(cursorbook.hasNext())
{	
	Document myBooks = cursorbook.next();
	Document myDoc2 = myBooks.get("studentID", Document.class);
	
 %>                                      
                                        <tr class="odd gradeX">
                                            
                                            <td class="center"><%=myDoc2.get("studentID")%></td>
                                            <td class="center"><%=myDoc2.get("fullName")%></td>
                                            <td class="center"><%=myDoc2.get("email")%></td>
                                            <td class="center"><%=myDoc2.get("mobile")%></td>
                                            <td class="center"><%=sum%></td>
                                           
                                        </tr>
												 <% } cursorbook.close(); %>                                      
                                    </tbody>
                                </table>
                            </div>
                            
                        </div>
                    </div>
                    <!--End Advanced Tables -->
                </div>
            </div>
<%  }  %>

            
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
    <!-- DATATABLE SCRIPTS  -->
    <script src="assets/js/dataTables/jquery.dataTables.js"></script>
    <script src="assets/js/dataTables/dataTables.bootstrap.js"></script>
      <!-- CUSTOM SCRIPTS  -->
    <script src="assets/js/custom.js"></script>
</body>
</html>
<% } %>
