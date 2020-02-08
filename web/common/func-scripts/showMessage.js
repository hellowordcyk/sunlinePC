function showMsg(message){
	$(".right_bottom_message").show("slow");
	$(".right_bottom_message").find(".message_text").append(message);
}
function hiddenMessage(event){
	$(event).closest("div").hide("slow");
}