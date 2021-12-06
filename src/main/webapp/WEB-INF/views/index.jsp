<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>fileupload</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
function appendItem(title, filename, filecode){
	const tr = $("<tr>");															
	const td_title = $("<td>").text(title);		//textContent 		
	const td_filename = $("<td>");
	const a_filename = $("<a>").text(filename).attr("href","upload/"+filecode);
	a_filename.attr("target","_blank");
	const td_delete = $("<td>");
	const a_delete = $("<a>").text("삭제").attr("href","delete/"+title);

	tr.append(td_title);
	td_filename.append(a_filename);
	tr.append(td_filename);
	td_delete.append(a_delete);
	tr.append(td_delete);
	
	$("tbody").append(tr);
}

$(function(){
	
	$("#list_code").click(function(){
		const title = $("input[name='title']").val();
		const filename = $("input[name='uploadFile']")[0].files[0].name;
		
		appendItem(title,filename);
		
	});
	
	$("#list").click(function(){
		
		const title = $("input[name='title']").val();
		const filename = $("input[name='uploadFile']")[0].files[0].name;
		
		console.log(title);
		console.log(filename);
		
		let html = "<tr><td>"+title+"</td><td>"+filename+"</td><td>삭제</td></tr>"
		
		//innerHtml
		const tbody = $("tbody").html(); //파라미터 없으면 게터
		$("tbody").html(tbody + html); //파라미터 있으면 세터
		
	});
});
$(function(){
	$("#upload").click(function(){
		const form = document.getElementById("uploadForm");
		const formData = new FormData(form);
		
		const title = form.title.value;
		const filename =  form.uploadFile.files[0].name;
		
		console.log(formData);
		$.ajax({
			type: "POST",
			url: "upload_ajax",
			enctype: "multipart/form-data",
			data: formData,
			async: true,
			cache: false,
			contentType: false,
			processData: false,
			success: function(result){
				alert("업로드 성공"+result);
				appendItem(title, filename, result);
			},
			error: function(xhr, status, err){
				alert("업로드 실패: "+err);
			}
			
		});
	});
});
</script>
</head>
<body>
	<div>
		<h3>이미지 업로드 갤러리</h3>
		<div>
			<table border="1">
				<thead>
					<tr>
						<th>제목</th>
						<th>파일명</th>
						<th>관리</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${list.size() < 1 }">
						<tr><td colspan="3">등록 된 이미지가 없습니다</td></tr>
					</c:if>
					<c:forEach var="item" items="${list}">
						<tr>
							<td>${item.title}</td>
							<td><a href="upload/${item.filecode}" target="_blank">${item.filename}</a></td>
							<td><a href="delete/${item.title}">삭제</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		<hr>
		<div>
			<form id="uploadForm" action="upload" method="post" enctype="multipart/form-data">
				<div>
					<label>제목:</label>
					<input type="text" name="title">
				</div>
				<div>
					<label>첨부파일:</label>
					<input type="file" name="uploadFile">
				</div>
				<div>
					<button>[FORM]등록</button>
				</div>
			</form>
		</div>
		<hr>
		<div>
			<button id="upload">[AJAX]등록</button>
		</div>
		<div>
			<button id="list">[LIST_HTML]등록</button>
		</div>
		<div>
			<button id="list_code">[LIST_CODE]등록</button>
		</div>
	</div>
</body>
</html>