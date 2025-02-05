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
	String target1State = studySession.v("realstart.target1State");
	String target2State = studySession.v("realstart.target2State");
	String target1Group = studySession.v("realstart.target1Group");
	String target2Group = studySession.v("realstart.target2Group");

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
			var target1Location = '<%=target1Group%>';
			var target2Location = '<%=target2Group%>';
			var target1State = '<%=target1State%>';
			var target2State = '<%=target2State%>';
			var dieWhere = (Math.random() > 0.5 ? 
				[' in his home (in ', ' at his place of work (in '] : 
				[' at his place of work (in ', ' in his home (in ']);
				
			require(['js/config'], function() 
			{
				require([ 'app/API'], function(API)
				{
                    API.addGlobal(
					{
						target1:'<%=target1Name%>', 
						target2:'<%=target2Name%>', 
						target1Image:(target1Location == 'USA' ? 'jamesusa.jpg' : 'jamesfrance.jpg'), 
						target2Image:(target2Location == 'USA' ? 'brianusa.jpg' : 'brianfrance.jpg'), 
						target1Location:(target1Location == 'USA' ? 'the USA' : 'France'), 
						target2Location:(target2Location == 'USA' ? 'the USA' : 'France'), 
						target1Where: (target1State == 'alive' ? ' in his hometown (in ' : dieWhere[0]), 
						target2Where: (target2State == 'alive' ? ' in his hometown (in ' : dieWhere[1]),
						target1State: (target1State == 'alive' ? 'lives' : 'died last week'), 
						target2State: (target2State == 'alive' ? 'lives' : 'died last week')
                    });

                    require(['<%= script %>'], function()
					{
                        API.play();
                    });                    
                });
            });
		</script>
	</head>

	<body>
	</body>
</html>
