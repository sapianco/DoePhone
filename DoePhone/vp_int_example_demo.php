<?php
	// set the VICIphone variables
	$layout = "css/default.css";
	$cid_name = "doephone";
	$sip_uri = "doephone@sapian.sbc.dialbox.cloud";
	$auth_user = "doephone";
	$password = "Xeech7doonga0hieZeCee3";
	$ws_server = "wss://sbc.dialbox.cloud/wss/sip/";
	$debug_enabled = "true";
	$hide_dialpad = false;
	$hide_dialbox = false;
	$hide_mute = false;
	$hide_volume = false;
	$auto_answer= false;
	
	// call the template
	require_once('vp_template.php');
?>
