$body = @'
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta content="en-us" http-equiv="Content-Language" />
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<title>Untitled 1</title>
<style type="text/css">
.auto-style1 {
	text-align: center;
}
.auto-style2 {
	font-family: arial, sans-serif;
	font-size: medium;
	color: #222222;
	letter-spacing: normal;
	background-color: #FFFFFF;
}
.auto-style3 {
	text-align: left;
}
.auto-style4 {
	font-size: large;
}
.auto-style5 {
	font-size: small;
}
.auto-style6 {
	border-width: 0px;
}
</style>
</head>

<body>

<p class="auto-style1">
<img src="http://www.careershealthcare.com/wp-content/uploads/2017/12/chs-logo.jpg"></p>
<p class="auto-style1">
&nbsp;</p>
<p class="auto-style1">
<span style="color: rgb(34, 34, 34); font-family: arial, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;" class="auto-style4">
<strong>Your Virtual Machine for @@{calm_username}@@ has been created</strong>!</span></p>
<br>


<p class="auto-style3">&nbsp;</p>
<p class="auto-style3">User: @@{calm_username}@@</p>
<p class="auto-style3">VM Name: @@{vmName}@@</p>
<p class="auto-style3">VM IP Address: @@{ip_address}@@</p>
<p class="auto-style3">VM Tag Applied; @@{TAG_NAME}@@</p>

<br>




<p class="auto-style3">&nbsp;</p>
<p class="auto-style3">For support, please contact the help desk by the 
following methods;</p>
<p class="MsoNormal">
<span style="mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-fareast-theme-font:minor-fareast;color:black;mso-no-proof:yes">To open a 
support ticket via Email: <a href="mailto:support@nutanix.com">
<span style="color:#0563C1">Nutanix Support</span></a> <o:p></o:p></span>
</p>
<p class="MsoNormal">
<span style="mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-fareast-theme-font:minor-fareast;color:black;mso-no-proof:yes">To open a 
support ticket via Phone: Call 888-555-5555<o:p></o:p></span></p>
<p class="auto-style1">&nbsp;</p>
<p class="auto-style1">
<span class="auto-style5" style="font-family: &quot;Arial&quot;,sans-serif; color: #666666">

Nutanix </span><span style="color:black"><o:p></o:p></span></p>
<p class="auto-style3">&nbsp;</p>
<p class="auto-style3">&nbsp;</p>
<p class="auto-style3">&nbsp;</p>
<p class="auto-style3">&nbsp;</p>

</body>

</html>
'@
# Send-MailMessage -To "broome@nutanix.com" -From "calm@chs.net" -Subject " Virtual Machine Deployed - @@{vmName}@@" -SmtpServer "ismtp.brentwood.tn.chs.net" -body $body -BodyAsHtml
