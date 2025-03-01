<%@page pageEncoding="UTF-8" %>
<%@page import="org.uva.*, java.io.*" %>
<%@page import="java.util.*, org.uva.*" errorPage="/research/ShowError.jsp"%>
<%@ taglib uri="/tags" prefix="pi" %>
<%

	String getProtocol=request.getScheme();
	String getDomain=request.getServerName();
	String getBase = getProtocol+"://"+getDomain;

	String script = request.getParameter("i");
	try{
		if (script == null){
			throw new Exception("Script is null");
		}
	} catch (Exception e){
		out.println("An exception occurred: " + e.getMessage());
	}

	StudySession studySession = (StudySession) session.getAttribute("studysession");
	String target1Name = studySession.v("realstart.target1Name");
	String target2Name = studySession.v("realstart.target2Name");

%>
<!DOCTYPE html>
<html>
	<head>
	<base href="<%= getBase + "/implicit/common/all/js/pip/0.2.0/dist/" %>">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>
        <meta HTTP-EQUIV="Expires" CONTENT="0"></meta>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"></meta>
        <meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache"></meta>
        <meta name="viewport" content="user-scalable=no, minimum-scale=1.0, maximum-scale=1.0, width=device-width, height=device-height" />

        <link type="text/css" rel="Stylesheet" href="css/reset.css"/>
        <link type="text/css" rel="Stylesheet" href="css/styles.css"/>
        <script language="JavaScript" type="text/javascript" src="/implicit/common/en-us/js/task.js"></script>
		<script src="js/libs/require.js"></script>

		<script>
			require(['js/config'], function() {
				require([ 'extensions/iat/PIcomponent'], function(IAT){
                    IAT.addGlobal({
						target1:'<%=target1Name%>', 
						target2:'<%=target2Name%>'
                    });
					require(['<%= script %>'], function()
					{
						IAT.play();
					});                    
				});
			});
		</script>
	</head>

	<body>
	</body>
</html>
