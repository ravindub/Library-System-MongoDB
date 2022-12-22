<%@page 
	import="com.mongodb.client.*,org.bson.Document" 
	import="org.bson.*,java.util.Date,java.text.SimpleDateFormat"
	import= "static com.mongodb.client.model.Filters.*"
	import= "static com.mongodb.client.model.Updates.*"
	import= "org.bson.types.ObjectId"
	import="com.library.db.dbConnect"%>
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

%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>ABC Library | Return Books</title>
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
                <h4 class="header-line">Return Issued Books</h4>
    </div>
    

            <div class="row">
                <div class="col-md-12">
                    <!-- Advanced Tables -->
                    <div class="panel panel-default">
                        <div class="panel-heading">
                          Issued Books 
                        </div>
                        <div class="panel-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered table-hover" id="dataTables-example">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Book Name</th>
                                            <th>ISBN </th>
                                            <th>Issued Date</th>
                                            <th>Return Date</th>
                                            <th>Fine in(LKR)</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
<%
	String sid=(String)session.getAttribute("stdid");
	MongoCollection<Document> collectionBook = db.getCollection("issuedbooks");
	FindIterable<Document> findIterable = collectionBook.find(eq("studentID.studentID", sid));
	
	
	MongoCursor<Document> cursor = findIterable.iterator();
	
	
	int cnt=1;
	while(cursor.hasNext())
	{
		Document myDoc = cursor.next();
		Document myDoc2 = myDoc.get("bookID", Document.class);
		//System.out.println(myDoc2);
		
		Date date = myDoc.getDate("issuedDate");
		Date returndate = myDoc.getDate("returnedDate");
		SimpleDateFormat DateFor = new SimpleDateFormat("yyyy-MM-dd");
		String stringDate= DateFor.format(date);
%>                                      
		<tr class="odd gradeX">
		<td class="center"><%=cnt%></td>
		<td class="center"><%=myDoc2.get("bookname")%></td>
		<td class="center"><%=myDoc2.get("isbn")%></td>
		<td class="center"><%=stringDate%></td>
		<td class="center"><%	if(myDoc.get("returnedDate")==null)
					{
				   %>
                                            <span style="color:red">
                                             <%="Not Return Yet"%>
                                                </span>
                                    <%  } 
					else
				    	{ 
				    %>

                                            <%String stringRetDate= DateFor.format(returndate);
                                            out.println(stringRetDate);%>

                                    <%  } 
				
                                    %></td>
		<td class="center"><%=myDoc.get("fine")%></td>
		 <td class="center">

          <a href="returnBooks.jsp?rid=<%=myDoc.get("_id")%>"><button class="btn btn-primary"><i class="fa fa-edit "></i> Edit</button> </a>
                                         
        </td>
                                         
		</tr>
<% 	cnt=cnt+1;
	} 
	
	cursor.close();
%>                                      
                                    </tbody>
                                </table>
                            </div>
                            
                        </div>
                    </div>
                    <!--End Advanced Tables -->
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
    <!-- DATATABLE SCRIPTS  -->
    <script src="assets/js/dataTables/jquery.dataTables.js"></script>
    <script src="assets/js/dataTables/dataTables.bootstrap.js"></script>
      <!-- CUSTOM SCRIPTS  -->
    <script src="assets/js/custom.js"></script>

</body>
</html>
<% } %>
