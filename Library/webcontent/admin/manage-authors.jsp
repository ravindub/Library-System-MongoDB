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
	MongoCollection<Document> collection = db.getCollection("authors");
	
	String id=request.getParameter("del");
	if(id!=null)
	{
		String sql = "delete from tblauthors  WHERE id=?";
		//ps=conn.prepareStatement(sql);
		//ps.setInt(1,Integer.parseInt(id));
		//ps.executeUpdate();

		session.setAttribute("delmsg","Author deleted scuccessfully");
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
    <title>ABC Library | Manage Authors</title>
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
                <h4 class="header-line">Manage Authors</h4>
    </div>
     <div class="row">
    <% String error=(String)session.getAttribute("error");
	if(error!=null)
    {%>
<div class="col-md-6">
<div class="alert alert-danger" >
 <strong>Error :</strong> 
 <%=error%>
<% session.setAttribute("error",null); %>
</div>
</div>
<% } %>
<% 
	String msg=(String)session.getAttribute("msg");
if(msg!=null)
{%>
<div class="col-md-6">
<div class="alert alert-success" >
 <strong>Success :</strong> 
 <%=msg%>
<% session.setAttribute("msg",null); %>
</div>
</div>
<% } %>
<% 
	String updatemsg=(String)session.getAttribute("updatemsg");
if(updatemsg!=null)
{%>
<div class="col-md-6">
<div class="alert alert-success" >
 <strong>Success :</strong> 
 <%=updatemsg%>
<% session.setAttribute("updatemsg",null); %>
</div>
</div>
<% } %>


   <% 
	String delmsg=(String)session.getAttribute("delmsg");	
if(delmsg!=null)
    {%>
<div class="col-md-6">
<div class="alert alert-success" >
 <strong>Success :</strong> 
 <%=delmsg%>
<% session.setAttribute("delmsg",null); %>
</div>
</div>
<% } %>

</div>


        </div>
            <div class="row">
                <div class="col-md-12">
                    <!-- Advanced Tables -->
                    <div class="panel panel-default">
                        <div class="panel-heading">
                           Authors Listing
                        </div>
                        <div class="panel-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered table-hover" id="dataTables-example">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Author</th>
                                         
                                            <th>Creation Date</th>
                                            <th>Updation Date</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
<% 
	MongoCursor<Document> cursor = collection.find().iterator();

	int cnt=1;
while(cursor.hasNext())
{             
	Document myDoc = cursor.next();
	
	
	
	%>                                      
                                        <tr class="odd gradeX">
                                            <td class="center"><%=cnt%></td>
                                            <td class="center"><%=myDoc.get("author")%></td>
                                             <td class="center"><%=myDoc.get("Creationdate")%></td>
                                            <td class="center"><%=myDoc.get("UpdationDate")%></td>
                                            <td class="center">

                                            <a href="edit-author.jsp?athrid=<%=myDoc.get("_id")%>"><button class="btn btn-primary"><i class="fa fa-edit "></i> Edit</button> </a>
                                          <a href="manage-authors.jsp?del=<%=myDoc.get("_id")%>" onclick="return confirm('Are you sure you want to delete?');" >  <button class="btn btn-danger"><i class="fa fa-pencil"></i> Delete</button></a>
                                            </td>
                                        </tr>
 <% cnt=cnt+1;} 
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