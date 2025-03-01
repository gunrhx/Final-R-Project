<%@ taglib uri="/tags" prefix="pi" %>
<%@page import="java.util.*, org.uva.*" errorPage="/research/ShowError.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" >
<head>
	<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
	<title>Implicit Association Test</title>
	<link rel="stylesheet" href="/implicit/research.css" type="text/css" />
	<script language="javascript" type="text/javascript" src="/implicit/common/en-us/js/task.js"></script>
	<style type="text/css">
		.hi { background-color: #eaf1dc; }
		.text {font-size:18px}
		.result {font-size:20px;font-weight:bold;background-color:lightyellow}
	</style>
<% 
	StudySession studySession = (StudySession) session.getAttribute("studysession");
	String iat = studySession.v("iat.feedback");
	
	String name1 = studySession.v("realstart.target1Name");
	String name2 = studySession.v("realstart.target2Name");
	String att1 = "pleasant words";
	String att2 = "unpleasant words";
	
	String fbHTML = "";
	fbHTML = fbHTML  + 
	"We measured your automatic attitudes with the <b>Implicit Association Test (the IAT).</b>" 
	+ " In this task you sorted items to four categories, using the keys 'e' and 'i'.<br/>";
	fbHTML = fbHTML + 
	"Your performance on this task is summarized below:</p><p align=\"left\" class=\"result\">" + iat + "</p>";
	fbHTML = fbHTML + 
	"<p class=\"text\">Your score was described as 'preference for " + name1 + " compared to " + name2 + "' if you were faster responding when <em>" + name1 + "</em> and <em>" + att1 + "</em> stimuli were assigned to the same response key than when giving the same response to the <em>" + name2 + "</em> and <em>" + att1 + "</em> stimuli. Conversely, your score was described as 'preference for " + name2 + " compared to " + name1 + "' if you were faster responding when <em>" + name2 + "</em> and <em>" + att1 + "</em> stimuli were assigned to the same key than when giving the same response to the <em>" + name1 + "</em> and <em>" + att1 + "</em> stimuli. Depending on the magnitude of your speed difference for the two combination tasks, your automatic (implicit) preference may be described as 'slight', 'moderate', 'strong', or 'little to no preference.'</p>";
	
	String target1State = studySession.v("realstart.target1State");
	String target2State = studySession.v("realstart.target2State");
	String target1Group = studySession.v("realstart.target1Group");
	String target2Group = studySession.v("realstart.target2Group");
	
	String explain = "<br/><br/>We provided you with very similar information about the two men: each performed two positive behaviors, two negative behaviors, and two neutral behaviors. ";
	if (!target1State.equals(target2State))
	{
		explain = explain + "However, we also told you that " + name1 + " is " + target1State + " and that " + name2 + " is " + target2State + ". We are testing whether you would have more negative automatic evaluation of dead people because these people are associated with a negative concept (death).";
	}
	else if (!target1Group.equals(target2Group))
	{
		if (target1Group.equals("USA")) 
		{
			target1Group = "the USA";
		}
		else if (target2Group.equals("USA")) 
		{
			target2Group = "the USA";
		}
		explain = explain + "However, we also told you that " + name1 + " is from " + target1Group + " and that " + name2 + " is from " + target2Group + ". We are testing whether American participants would have an automatic preference for the American person over the French person.";
	}
	else
	{
		explain = explain + "We are testing whether even when the information about each man is relatively equal, people would tend to have an automatic preference for one man over the other";
	}
%>
</head>
<body>

<form method="post" action="/implicit/Study" name="form2">
<input type="hidden" name="mode" value="insQuesData" />

<table width="100%">
	<tr><td align="center">
		<table class="core" width="900" cellpadding="10" cellspacing="0" border="0">
		<tr>
			<td align="left"><p align="center" class="text"><strong>You have completed the study.</strong></p>
			<p class="text">Thank you for your participation.<br/><br/>
			In this study we introduced you to two men and then measured your attitudes toward them. 
			We asked you how you feel about them, and also measured your automatic attitude towards them.  
			An automatic attitude is your very first evaluation of a person or an object, 
			activated automatically with no need for conscious intention to evaluate that person or object. 
			Your automatic attitude might be different than the attitude that you explicitly endorse. 
			For instance, a person might endorse a preference for <%=name1%> over <%=name2%>, 
			but show an automatic preference for <%=name2%> over <%=name1%>. 
			<%=explain%><br/><br/><%=fbHTML%>
		</td></tr>
	   <tr> 
		  <td class=text> 
			<p class="text">
				<strong>Important:</strong> The results 
				are not a definitive assessment of your automatic preference. 
				The results may be influenced by a number of variables, such as the 
				order that the measures were presented, or the particular items used 
				to represent the categories. The results are provided for 
				entertainment and educational purposes only.
			</p>
		 </td>
		</tr>
		<tr> 
		  <td class=text> 
			<p class="text">
			If you have unanswered questions about the task, 
			please review <a href="/implicit/backgroundinformation.html"> background information</a>  
			about this research or email Daniel Feldman, <a href="mailto:delbif@gmail.com">delbif@gmail.com</a> with questions or comments.</p>
			<p>You can click <a href="javascript:window.print()" onMouseover="return status='Print this page'" onMouseout="return status=''">here</a> to print this page.</p>
			<p><strong>Thank you again for your participation! </strong></p>
			<p align="center"><button class=heading onclick="window.location='/implicit/research'">Start next study</button><br/><br/><a href="/implicit/backgroundinformation.html">Background Information</a> || <a href="/implicit/privacy.html">Privacy Information</a> || <a href="/implicit">Project Implicit Home</a></p>
		</td></tr>
	</td></tr></table></center>
	<tr><td align="center">
		<table width="600" cellpadding="10" cellspacing="0" border="0">
		<tr><td align="center">
			<p class="smltext"><a href="/implicit/demo/copyright.html">Copyright &copy; IAT Corp.</a></p>
		</td></tr>
		</table>
	</td></tr>
</table>

</form>
</body>
</html>