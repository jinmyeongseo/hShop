<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style type="text/css">
.body-container {
	max-width: 1000px;
}

.special-img { width: 100%; max-height: 130px; }

.table-list thead > tr > th { padding-top: 10px; padding-bottom: 10px; }
.table-list tbody > tr { vertical-align: middle; }
.table-list tbody tr > td { text-align: center; }
.table-list .left { text-align: left; padding-left: 10px; }

.search-productName { cursor: pointer; }
.search-productName:hover { color: #0d6efd;}
</style>

<script type="text/javascript">
function deleteOk() {
	let query = "specialNum=${dto.specialNum}&${query}&imageFilename=${dto.imageFilename}";
    let url = "${pageContext.request.contextPath}/admin/specials/${classify}/delete?" + query;

    if(confirm("등록된 자료를 삭제 하시 겠습니까 ? ")) {
  	  location.href = url;
    }
}
</script>

<div class="container">
	<div class="body-container">
		<div class="body-title">
			<h3><i class="bi bi-app"></i> ${classify==200 ? "오늘의 특가" : "기획전"} </h3>
		</div>
		
		<div class="body-main p-3">
			<div class="row p-3 ms-1 me-1 bg-light rounded">
				<div class="col-4 border rounded p-1">
					<img class="rounded special-img" src="${pageContext.request.contextPath}/uploads/specials/${dto.imageFilename}">
				</div>
				<div class="col align-self-center">
					<h3 class="mb-2">
						${dto.subject}
					</h3>
					<div class="mb-2">
						기간 : ${dto.startDate} ~ ${dto.endDate} 
					</div>
					<div>
						등록일 : ${dto.reg_date} 
					</div>
				</div>
			</div>
			
			<div class="mt-2 mb-2">
				${dto.content}
			</div>
			
			<div class="row mb-2">
				<div class="col">
					<button type="button" class="btn btn-light" onclick="location.href='${pageContext.request.contextPath}/admin/specials/${classify}/update?specialNum=${dto.specialNum}&page=${page}';">수정</button>
					<button type="button" class="btn btn-light btn-specialsDelete" onclick="deleteOk();">삭제</button>
				</div>
				<div class="col text-end">
					<button type="button" class="btn btn-light" onclick="location.href='${pageContext.request.contextPath}/admin/specials/${classify}/main?${query}';">리스트</button>
				</div>
			</div>
			
			<hr>
			
			<div class="pt-4">
				<h4 class="pb-2">등록 상품</h4>
				
				<div class="pb-2 text-end">
					<button type="button" class="btn btn-light btn-append">상품등록</button>
				</div>
				<table class="table table-border table-list">
					<thead>
						<tr class="border-top border-dark table-light text-center">
							<th width="130">상품코드</th>
							<th>상품명</th>
							<th width="80">출력순서</th>
							<th width="110">출력</th>
							<th width="130">변경</th>
						</tr>
					</thead>
					<tbody class="product-list"></tbody>
				</table>
				
				<div class="page-navigation"></div>	
					
			</div>
		</div>
	</div>
</div>

<!-- 등록/수정 대화상자 -->
<div class="modal fade modal-lg" id="prodectSaveModal" aria-labelledby="prodectSaveModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="prodectSaveModalLabel">${classify==200 ? "오늘의 특가" : "기획전"} 상품</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body pt-1 saveProduct-form">
				<table class="table">
					<tr>
						<td class="text-center align-middle">상품명</td>
						<td>
							<div class="input-group mb-3">
								<input type="text" name="productName" class="form-control" readonly>
								<button type="button" class="btn btn-light btn-search ms-1" title="검색"><i class="bi bi-search"></i></button>
							</div>						
						</td>
					</tr>
					<tr>
						<td class="text-center align-middle">상품코드</td>
						<td>
							<input type="text" name="productNum" class="form-control border-0 w-50" readonly>
						</td>
					</tr>
					<tr>
						<td class="text-center align-middle">출력순서</td>
						<td>
							<input type="text" name="displayOrder" class="form-control w-50">
						</td>
					</tr>
					<tr>
						<td class="text-center align-middle">출력</td>
						<td>
							<select name="showDetail" class="form-select w-50">
								<option value="1">표시</option>
								<option value="0">숨김</option>
							</select>
						</td>
					</tr>
				</table>
				
				<table class="table table-borderless">
					<tr>
						<td class="text-end">
							<input type="hidden" name="mode">
							<input type="hidden" name="detailNum" value="0">
							<button type="button" class="btn btn-outline-primary btn-productSave">등록</button>
			    			<button type="button" class="btn btn-outline-danger btn-productCancel">취소</button>
						</td>
					</tr>
				</table>				
			</div>
		</div>
	</div>
</div>

<!-- 상품 검색 대화상자 -->
<div class="modal fade" id="prodectSearchModal" tabindex="-1" aria-labelledby="searchModalLabel"
				aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="searchViewerModalLabel">상품검색</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
                <div class="row search-form">
					<div class="col-4 pe-1">
						<select name="schType" class="form-select">
							<option value="prodectName">상품명</option>
							<option value="prodectNum">상품코드</option>
						</select>
					</div>
					<div class="col ps-0 pe-1">
						<input type="text" name="kwd" class="form-control">
					</div>
					<div class="col-auto ps-0 pe-2">
						<button type="button" class="btn btn-light btn-productSearch" title="검색"><i class="bi bi-search"></i></button>
					</div>
                </div>
               	<div class='row mt-2 border-top border-bottom bg-light p-2'>
               	 	<div class='col-3 text-center'>상품코드</div>
               	 	<div class='col ps-2'>상품명</div>
               	</div>
                <div class="product-search-list"></div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
function login() {
	location.href = '${pageContext.request.contextPath}/member/login';
}

function ajaxFun(url, method, formData, dataType, fn, file = false) {
	const settings = {
			type: method, 
			data: formData,
			dataType:dataType,
			success:function(data) {
				fn(data);
			},
			beforeSend: function(jqXHR) {
				jqXHR.setRequestHeader('AJAX', true);
			},
			complete: function () {
			},
			error: function(jqXHR) {
				if(jqXHR.status === 403) {
					login();
					return false;
				} else if(jqXHR.status === 400) {
					alert('요청 처리가 실패 했습니다.');
					return false;
		    	}
		    	
				console.log(jqXHR.responseText);
			}
	};
	
	if(file) {
		settings.processData = false;  // file 전송시 필수. 서버로전송할 데이터를 쿼리문자열로 변환여부
		settings.contentType = false;  // file 전송시 필수. 서버에전송할 데이터의 Content-Type. 기본:application/x-www-urlencoded
	}
	
	$.ajax(url, settings);
}

$(function(){
	listPage(1);	
});

function listPage(page) {
	let url = "${pageContext.request.contextPath}/admin/specials/${classify}/productList";
	let query = "specialNum=${dto.specialNum}&pageNo=" + page;
	
	const fn = function(data){
		let dataCount = parseInt(data.dataCount);
		
		$(".product-list").html("");
		$(".btn-specialsDelete").prop("disabled", true)
		if(dataCount === 0) {
			$(".page-navigation").html("등록된 상품이 없습니다");
			$(".btn-specialsDelete").prop("disabled", false)
		} else {
			printProduct(data);
		}
	};
	
	ajaxFun(url, "get", query, "json", fn);
}

function printProduct(data) {
	let list = data.list;
	let dataCount = parseInt(data.dataCount);
	let pageNo = data.pageNo;
	let total_page = data.total_page;
	let size = data.size;
	let paging = data.paging;
	
	let out = "";
	for(let item of list) {
		let detailNum = item.detailNum;
		let productNum = item.productNum;
		let productName = item.productName;
		let displayOrder = item.displayOrder;
		let showDetail = item.showDetail;
		let s = showDetail === 1 ? "표시" : "숨김";

		out += "<tr>";
		out += "  <td>"+productNum+"</td>";
		out += "  <td class='left'>"+productName+"</td>";
		out += "  <td>"+displayOrder+"</td>";
		out += "  <td data-showDetail='"+showDetail+"'>"+s+"</td>";
		out += "  <td>";
		out += "    <button type='button' class='btn btn-light btn-update' title='수정' data-detailNum='"+detailNum+"'><i class='bi bi-pencil'></i></button>";
		out += "    <button type='button' class='btn btn-light btn-delete' title='삭제' data-detailNum='"+detailNum+"'><i class='bi bi-trash3'></i></button>";
		out += "  </td>";
		out += "</tr>";
		
	}
	$(".product-list").html(out);
	$(".product-list").attr("data-pageNo", pageNo);
	$(".page-navigation").html(paging);
}

$(function(){
	// 상품 등록 버튼
	$(".btn-append").click(function(){
		$(".saveProduct-form input[name=productNum]").val("");
		$(".saveProduct-form input[name=productName]").val("");
		$(".saveProduct-form input[name=displayOrder]").val("");
		$(".saveProduct-form select[name=showDetail]").val("1");
		
		$(".saveProduct-form input[name=detailNum]").val("0");
		$(".saveProduct-form input[name=mode]").val("insert");
		
		$(".saveProduct-form .btn-productSave").text("등록");

		$("#prodectSaveModal").modal("show");
	});

	// 등록 상품 수정 버튼
	$("body").on("click", ".btn-update", function(){
		let detailNum = $(this).attr("data-detailNum")
		let productNum = $(this).closest("tr").find("td:first-child").text().trim();
		let productName = $(this).closest("tr").find("td:nth-child(2)").text().trim();
		let displayOrder = $(this).closest("tr").find("td:nth-child(3)").text().trim();
		let showDetail = $(this).closest("tr").find("td:nth-child(4)").attr("data-showDetail");
		
		$(".saveProduct-form input[name=detailNum]").val(detailNum);
		$(".saveProduct-form input[name=productNum]").val(productNum);
		$(".saveProduct-form input[name=productName]").val(productName);
		$(".saveProduct-form input[name=displayOrder]").val(displayOrder);
		$(".saveProduct-form select[name=showDetail]").val(showDetail);

		$(".saveProduct-form input[name=mode]").val("update");
		$(".saveProduct-form .btn-productSave").text("수정");		
		
		$("#prodectSaveModal").modal("show");
	});

	// 등록 상품 삭제 버튼
	$("body").on("click", ".btn-delete", function(){
		if( ! confirm('등록된 상품을 삭제 하시겠습니까 ? ') ) {
			return false;	
		}
		
		let detailNum = $(this).attr("data-detailNum")
		let page = $(".product-list").attr("data-pageNo");
		
		let url = "${pageContext.request.contextPath}/admin/specials/${classify}/productDelete";
		let query = "detailNum="+detailNum;
		
		const fn = function(data){
			listPage(page);
		};
		
		ajaxFun(url, "post", query, "json", fn);
	});
	
	// 상품등록(수정)대화상자 - 등록완료/수정완료
	$(".btn-productSave").click(function(){
		let mode = $(".saveProduct-form input[name=mode]").val();

		let specialNum = "${dto.specialNum}";
		let detailNum = $(".saveProduct-form input[name=detailNum]").val();
		let productNum = $(".saveProduct-form input[name=productNum]").val();
		let displayOrder = $(".saveProduct-form input[name=displayOrder]").val();
		let showDetail = $(".saveProduct-form select[name=showDetail]").val();
		
		if( ! productNum ) {
			return false;
		}

		if( ! /^\d{1,5}$/.test(displayOrder) ) {
			alert("5자리 이하 정수만 가능합니다.")
			$(".saveProduct-form input[name=displayOrder]").focus();
			return false;
		}
		
		let query = "";
		let url = "";
		if(mode==="insert") {
            query = "specialNum="+specialNum+"&productNum="+productNum+"&displayOrder="+displayOrder+
                    "&showDetail="+showDetail;
            url = "${pageContext.request.contextPath}/admin/specials/${classify}/productInsert";
		} else { // update
			let detailNum = $(".saveProduct-form input[name=detailNum]").val();
            query = "productNum="+productNum+"&displayOrder="+displayOrder+
                    "&showDetail="+showDetail+"&detailNum=" + detailNum;
            url = "${pageContext.request.contextPath}/admin/specials/${classify}/productUpdate";
		}
		
		const fn = function(data){
			$("#prodectSaveModal").modal("hide");
			let page = "1"
			if(mode === "update") {
				page = $(".product-list").attr("data-pageNo");
			}
			listPage(page);
		};
		
		ajaxFun(url, "post", query, "json", fn);

	});
	
	// 상품등록(수정)대화상자 - 취소
	$(".btn-productCancel").click(function(){
		$("#prodectSaveModal").modal("hide");
	});
	
	// 상품등록(수정)대화상자 - 검색
	$(".btn-search").click(function(){
		// 상품검색 대화상자 출력
		$(".search-form select[name=schType]").val("prodectName");
	    $(".search-form input[name=kwd]").val("");
		$(".product-search-list").html("");
		
		$("#prodectSearchModal").modal("show");
	});

	// 상품검색 대화상자-검색 버튼
	$(".btn-productSearch").click(function(){
    	$(".product-search-list").html("");
    	
		let schType = $(".search-form select[name=schType]").val();
	    let kwd = $(".search-form input[name=kwd]").val();
	    let specialNum = "${dto.specialNum}";
		
	    let query = "specialNum="+specialNum+"&schType="+schType+"&kwd="+encodeURIComponent(kwd);
	    let url = "${pageContext.request.contextPath}/admin/specials/${classify}/productSearch";

	    const fn = function(data) {
	    	let out = "";
	    	for(let item of data.list) {
	    		let productNum = item.productNum;
	    		let productName = item.productName;
	    		
	    		out += "<div class='row mb-2 p-2 border-bottom'>";
	    		out += "  <div class='col-3 text-center'>"+productNum+"</div>"
	    		out += "  <div class='col ps-2 search-productName' data-productNum='"+productNum+"'>"+productName+"</div>";
	    		out += "</div>"; 
	    	}
	    	
	    	$(".product-search-list").html(out);
		};
		
		ajaxFun(url, "get", query, "json", fn);
	    
	});
	
	// 상품검색 대화상자-검색된 상품을 클릭한 경우
	$("body").on("click", '.search-productName', function(){
		let productNum = $(this).attr("data-productNum");
		let productName = $(this).text().trim();
		
		$(".saveProduct-form input[name=productNum]").val(productNum);
		$(".saveProduct-form input[name=productName]").val(productName);
		
		$("#prodectSearchModal").modal("hide");
		
		$(".saveProduct-form input[name=displayOrder]").focus();
	});
});

</script>
