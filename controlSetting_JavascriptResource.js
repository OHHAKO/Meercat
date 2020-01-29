

function getSelectElement(dataFromXml) {

	var floorArray = dataFromXml.getElementsByTagName("floor");
	
	var pcArray = dataFromXml.getElementsByTagName("client");
	//$('#selectGroupInGMT').removeAttr("disabled");
	//$('#selectGroupInGMT').attr("disabled", "disabled");
	for (var i = 0; i < floorArray.length; i++) {
		$('.selectFloor').append(
				"<option class='optionFloor'" + "optionFloor='"
						+ floorArray[i].getAttribute('name') + "'>"
						+ floorArray[i].getAttribute('name') + "</option>");
	}
	
	$('.selectFloor').change(function(){
		var selectedFloor=$(this).val();
		
		if(selectedFloor=="All Floor"){
			resetSelectGroup();
			resetSelectPC();
			$('.selectGroup').attr("disabled","disabled");
			$('.selectPC').attr("disabled","disabled");
		}else{
			$('.selectGroup').removeAttr("disabled");
			$('.selectPC').removeAttr("disabled");
			resetSelectGroup();
			resetSelectPC();
			showSelectGroup($(this).val(),dataFromXml,floorArray);
		}
		
	});
}


function showSelectGroup(selectedFloor,dataFromXml,floorArray){
	var classArray = dataFromXml.getElementsByTagName("class");
	
	var clsArray;
	console.log(floorArray.length);
	for(var i=0; i<floorArray.length ;i++ ){ //floor 목록중에
		if(selectedFloor==floorArray[i].getAttribute('name')){
			clsArray = floorArray[i].getElementsByTagName("class");//이 floor에 해당되는 class배열
			alert("선택한 floor는 "+floorArray[i].getAttribute('name'));
			
		}
	}
	
	for(var j=0;j<clsArray.length;j++){
		$('.selectGroup').append("<option>"+clsArray[j].getAttribute('name')+"</option>");
	}
	
	$('.selectGroup').change(function(){
		var selectedGroup = $(this).val();
		if(selectedGroup=="All Group"){
			resetSelectPC();
			$('.selectPC').attr("disabled","disabled");
		}else{
			$('.selectPC').removeAttr("disabled");
			resetSelectPC();
			showSelectPC($(this).val(),dataFromXml,clsArray);
		}
	})
}

function showSelectPC(selectedGroup,dataFromXml,classArray){
	var selected
	var pcArray;
	for(var i=0 ; i<classArray.length ; i++){
		if(selectedGroup==classArray[i].getAttribute('name')){
			pcArray=classArray[i].getElementsByTagName('client');
		}
		
	}

	for(var j=0 ; j<pcArray.length ; j++){
		pcId = pcArray[j].getAttribute('name').split('-');
		pcId = pcId[1];
		$('.selectPC').append("<option>"+pcId+"<option>");
	}
	
}






function resetSelectFloor(){
	$('.selectFloor').html("<option>All Floor</option>")
}

function resetSelectGroup(){
	$('.selectGroup').html("<option>All Group</option>")
}

function resetSelectPC(){
	$('.selectPC').html("<option>All PC</option>")
}


/*function a(abc,xmlData){
	var abc= 0;
	//dataFromXml.getElementsByTagName("floor");
	
	$(xmlData).find("floor").each(
			function(){
				abc = abc+1
			})
	alert(abc);
	
}*/

















