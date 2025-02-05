<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<title>Implicit Association Test</title>
	<script type="text/javascript" src="/implicit/common/en-us/js/task.js"></script>
	<script type="text/javascript" src="/implicit/common/en-us/js/swfobject.js"></script>
    <meta http-equiv="expires" content="0" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Cache-Control" content="no-cache" />

    <script type="text/javascript">
	<!--
	    var studyWindow;
	    function newWindow(sessionId)
	    {
			document.getElementById('frmInstructions').pageLoaded.value = "true" ;
			studyWindow = window.open("/implicit/Study;jsessionid=<%=session.getId()%>?tid="+xGetCookie("tid"), "Study", "width=800,height=600,resizable,scrollbars,status") ;
			if (!studyWindow.opener) studyWindow.opener = self ;
			studyWindow.focus() ;
	    }
	    function closeStudyWindow()
	    {
			if (studyWindow && !studyWindow.closed)
			{
				studyWindow.close() ;
				studyWindow = null ;
	        }
	    }
	    function popperupper()
	    {
			newWindow() ;
			document.getElementById('startlink').style.visibility = "hidden" ;
	    }
	//-->
	</script>
    
	
	<style type="text/css">
		body { 	background-color: #dcdcdc; padding: 0px; margin: 0px; }
		p, h1, h2, h3, ol { font-family: arial, helvetica, sans-serif; }
		li { margin: 0px 0px 10px 0px; font-size: 80%; }
		.core { background-color: #ffffff; }
		.dblu { background-color: #2c6eac; }
		img { padding: 0px; margin: 0px; display: block; border-style: none; }
		.smltext { font-family: verdana, arial, helvetica, sans-serif; font-size: 70%; color: #000000; }
	</style>

	<link rel="stylesheet" href="/implicit/common/en-us/css/demo.css" type="text/css" />
	
</head>

<body onunload="closeStudyWindow()">

<table width="100%" cellpadding="0" cellspacing="0" border="0">
<tr><td align="center">

<table width="664" cellpadding="0" cellspacing="0" border="0" id="header">
<tr class="dblu">
	<td align="left"><a href="/implicit/"><img src="/implicit/common/en-us/image/siteimages/demhead.gif"  alt="Implicit Association Test" height="49" /></a></td>
</tr>
</table>
	<br />
	<table class="core" width="600" cellpadding="20" cellspacing="0">
		<tr>
			<td align="left">
				<ol>
					<li>For best results, minimize distractions and close other programs.</li>
					<li>Problems? See <a href="/implicit/demo/support/index.jsp">technical support information</a> or <a href="/implicit/demo/support/notify.jsp">contact us</a>. </li>
					</ol>

			<span id="startlink"><h2 align="center">
			<div id="flashcontent">&nbsp;</div>
			<script type="text/javascript">
				var fo = new SWFObject("/implicit/common/en-us/flash/check2.swf", "check2", "30", "30", "6", "#FFFFFF");
				fo.addParam("quality", "high");
				fo.write("flashcontent");
			</script>
			See the green checkmark? <script language="JavaScript" type="text/javascript">writeLink("Click here to begin");</script></h2>
			<p align="center"><FONT face=Arial>If not, click <a href="/implicit/demo/support/noflash.html">here</a>.</FONT></p>
		</tr>
	</table>

	<table width="600" cellpadding="10" cellspacing="0" border="0">
		<tr>
			<td align="left"><p class="smltext">Copyright &copy; IAT Corp.</p></td>
		</tr>
	</table></td>
</tr>
</table>

<form id="frmInstructions" action="">
	<div><input type="hidden" name="pageLoaded" id="pageLoaded" value="false" /></div>
</form>

	<div style="display:none">
	  <img src='/implicit/user/ybalab/daniel/death1/images/brian.jpg'/>
	  <img src='/implicit/user/ybalab/daniel/death1/images/brian1.jpg'/>
	  <img src='/implicit/user/ybalab/daniel/death1/images/brian2.jpg'/>
	  <img src='/implicit/user/ybalab/daniel/death1/images/brianfrance.jpg'/>
	  <img src='/implicit/user/ybalab/daniel/death1/images/brianusa.jpg'/>
	  <img src='/implicit/user/ybalab/daniel/death1/images/james.jpg'/>
	  <img src='/implicit/user/ybalab/daniel/death1/images/james1.jpg'/>
	  <img src='/implicit/user/ybalab/daniel/death1/images/james2.jpg'/>
	  <img src='/implicit/user/ybalab/daniel/death1/images/jamesfrance.jpg'/>
	  <img src='/implicit/user/ybalab/daniel/death1/images/jamesusa.jpg'/>
	</div>

</body>
</html>
