<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style type="text/css">
.body-container {
	max-width: 900px;
}

.table-form tr>td { vertical-align: middle; }
.table-form tr:first-child { border-top: 2px solid #212529; }
.table-form tr>td:first-child { text-align: center; }
.table-form tr>td:nth-child(2) { padding-left: 10px; }
.table-form textarea { height: 170px; resize: none; }

.table-form .image-viewer {
	cursor: pointer;
	border: 1px solid #c2c2c2;
	width: 50px; height: 50px; border-radius: 10px;
	background-image: url("${pageContext.request.contextPath}/resources/images/add_photo.png");
	position: relative;
	z-index: 9999;
	background-repeat: no-repeat;
	background-size: cover;
}
</style>

<script type="text/javascript">
function isValidDateFormat(data){
	if(data.length !== 8 && data.length !== 10) return false;
		
	let p = /(\.)|(\-)|(\/)/g;
	data = data.replace(p, "");
	if(data.length !== 8) return false;
	
	let format = /^[12][0-9]{7}$/;
	if(! format.test(data)) return false;
    
	let y = parseInt(data.substr(0, 4));
	let m = parseInt(data.substr(4, 2));
	let d = parseInt(data.substr(6));

	if(m<1 || m>12) return false;
	let lastDay = (new Date(y, m, 0)).getDate();
	if(d<1 || d>lastDay) return false;
	
	return true;
}

function check() {
	const f = document.specialsForm;
	let str, b;
	
	if(! f.subject.value.trim()) {
		alert("제목을 입력하세요.");
		f.subject.focus();
		return false;
	}
	
	if(! isValidDateFormat(f.sday.value)) {
		alert("날짜를 입력하세요.");
		f.sday.focus();
		return false;
	}
	
	if(! /^[0-2][0-9]:[0-5][0-9]$/.test(f.stime.value)) {
		alert("시간을 입력하세요.");
		f.stime.focus();
		return false;
	}


	if(! isValidDateFormat(f.eday.value)) {
		alert("날짜를 입력하세요.");
		f.eday.focus();
		return false;
	}
	
	if(! /^[0-2][0-9]:[0-5][0-9]$/.test(f.etime.value)) {
		alert("시간을 입력하세요.");
		f.etime.focus();
		return false;
	}
	
	let sd = new Date(f.sday.value + " " + f.stime.value);
	let ed = new Date(f.eday.value + " " + f.etime.value);
	
	if( sd.getTime() >= ed.getTime() ) {
		alert("시작날짜는 종료날짜보다 크거나 같을 수 없습니다.");
		f.sday.focus();
		return false;
	}

	if( new Date().getTime() > ed.getTime() ) {
		alert("종료날짜는 현재 시간보다 작을수 없습니다.");
		f.eday.focus();
		return false;
	}
	
	b = false;
	for(let s of f.showSpecial) {
		if( s.checked ) {
			b = true;
			break;
		}
	}
	if( ! b ) {
		alert("표시 여부를 선택하세요.");
		f.showSpecial[0].focus();
		return false;
	}
	
	str = f.content.value.trim();
	if( !str || str === "<p><br></p>" ) {
		alert("상품 설명을 입력하세요.");
		f.content.focus();
		return false;
	}
	
    let mode = "${mode}";
    if( (mode === "write") && (! f.selectFile.value) ) {
        alert("이미지 파일을 추가 하세요. ");
        f.selectFile.focus();
        return;
	}  
    
	f.action = "${pageContext.request.contextPath}/admin/specials/${classify}/${mode}";
	return true;
}
</script>

<div class="container">
	<div class="body-container">
		<div class="body-title">
			<h3><i class="bi bi-app"></i> ${classify==200 ? "오늘의 특가" : "기획전"} </h3>
		</div>
		
		<div class="body-main">
		
			<form name="specialsForm" method="post" enctype="multipart/form-data">
				<table class="table mt-5 table-form">
					<tr>
						<td class="table-light col-sm-2">제목</td>
						<td>
							<input type="text" name="subject" class="form-control" value="${dto.subject}">
							<input type="hidden" name="classify" value="${classify}">
						</td>
					</tr>
					<tr>
						<td class="table-light col-sm-2">시작일자</td>
						<td>
							<div class="col-sm-10 row">
								<div class="col-sm-4 pe-1">
									<input type="date" name="sday" class="form-control" value="${dto.sday}">
								</div>
								<div class="col-sm-4 p2-1">
									<input type="time" name="stime" class="form-control" value="${dto.stime}">
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td class="table-light col-sm-2">종료일자</td>
						<td>
							<div class="col-sm-10 row">
								<div class="col-sm-4 pe-1">
									<input type="date" name="eday" class="form-control" value="${dto.eday}">
								</div>
								<div class="col-sm-4 p2-1">
									<input type="time" name="etime" class="form-control" value="${dto.etime}">
								</div>
							</div>
						</td>
					</tr>
					
					<tr>
						<td class="table-light col-sm-2">표시 여부</td>
						<td>
							<div class="pt-2 pb-2">
								<input type="radio" name="showSpecial" class="form-check-input" id="showSpecial1" value="1" ${empty dto || dto.showSpecial==1 ? "checked" : "" }> <label class="form-check-label" for="showSpecial1">표시</label>
								&nbsp;&nbsp;
								<input type="radio" name="showSpecial" class="form-check-input" id="showSpecial0" value="0" ${dto.showSpecial==0 ? "checked" : "" }> <label class="form-check-label" for="showSpecial0">숨김</label>
							</div>
						</td>
					</tr>

					<tr>
						<td class="table-light col-sm-2">설명</td>
						<td>
							<textarea name="content" id="ir1" class="form-control" style="max-width: 95%; height: 290px;">${dto.content}</textarea>
						</td>
					</tr>
					
					<tr>
						<td class="table-light col-sm-2">이미지</td>
						<td>
							<div class="image-viewer"></div>
							<input type="file" name="selectFile" accept="image/*" class="form-control" style="display: none;">
						</td>
					</tr>
					
				</table>
				
				<table class="table table-borderless">
					<tr>
						<td class="text-center">
							<button type="button" class="btn btn-dark" onclick="submitContents(this.form);">${mode=="update"?"수정완료":"등록완료"}</button>
							<button type="reset" class="btn btn-light">다시입력</button>
							<button type="button" class="btn btn-light" onclick="location.href='${pageContext.request.contextPath}/admin/specials/${classify}/main';">${mode=="update"?"수정취소":"등록취소"}</button>
							<c:if test="${mode=='update'}">
								<input type="hidden" name="specialNum" value="${dto.specialNum}">
								<input type="hidden" name="imageFilename" value="${dto.imageFilename}">
								<input type="hidden" name="page" value="${page}">
							</c:if>
						</td>
					</tr>
				</table>
			</form>
		
		</div>
	</div>
</div>

<script type="text/javascript">
// 이미지
$(function(){
	var img = "${dto.imageFilename}";
	if( img ) { // 수정인 경우
		img = "${pageContext.request.contextPath}/uploads/specials/"+img;
		$(".table-form .image-viewer").empty();
		$(".table-form .image-viewer").css("background-image", "url("+img+")");
	}
	
	$(".table-form .image-viewer").click(function(){
		$("form[name=specialsForm] input[name=selectFile]").trigger("click");
	});
	
	$("form[name=specialsForm] input[name=selectFile]").change(function(){
		let file = this.files[0];
		
		if(! file) {
			$(".table-form .image-viewer").empty();
			
			if( img ) {
				img = "${pageContext.request.contextPath}/uploads/specials/"+img;
			} else {
				img = "${pageContext.request.contextPath}/resources/images/add_photo.png";
			}
			$(".table-form .image-viewer").css("background-image", "url("+img+")");
			
			return false;
		}
		
		if( ! file.type.match("image.*") ) {
			this.focus();
			return false;
		}
		
		var reader = new FileReader();
		reader.onload = function(e) { // 파일의 내용을 다 읽었으면
			$(".table-form .image-viewer").empty();
			$(".table-form .image-viewer").css("background-image", "url("+e.target.result+")");
		};
		reader.readAsDataURL( file );
	});
});
</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/vendor/se2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">
var oEditors = [];
nhn.husky.EZCreator.createInIFrame({
	oAppRef: oEditors,
	elPlaceHolder: "ir1",
	sSkinURI: "${pageContext.request.contextPath}/resources/vendor/se2/SmartEditor2Skin.html",
	fCreator: "createSEditor2"
});

function submitContents(elClickedObj) {
	 oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
	 try {
		if(! check()) {
			return;
		}
		
		elClickedObj.submit();
		
	} catch(e) {
	}
}

function setDefaultFont() {
	var sDefaultFont = '돋움';
	var nFontSize = 12;
	oEditors.getById["ir1"].setDefaultFont(sDefaultFont, nFontSize);
}
</script>