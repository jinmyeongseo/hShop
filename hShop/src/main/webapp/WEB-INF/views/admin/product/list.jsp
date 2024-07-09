<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style type="text/css">
.body-container {
	max-width: 1100px;
}

.nav-tabs .nav-link {
	min-width: 170px;
	background: #f3f5f7;
	border-radius: 0;
	border-right: 1px solid #dbdddf;
	color: #333;
	font-weight: 600;
}
.nav-tabs .nav-link.active {
	background: #3d3d4f;
	color: #fff;
}
.tab-pane { min-height: 300px; }

.table-list { width: 100%; }
.table-list thead { color: #787878; }
.table-list tr>th { padding-top: 10px; padding-bottom: 10px; }
.table-list tr>th, .table-list tr>td { text-align: center; }
.table-list .left { text-align: left; padding-left: 7px; }
.table-list .right { text-align: right; padding-left: 7px; padding-right: 7px; }

.product-subject {
	width: 330px;
}
.product-subject img {
	vertical-align: top;
	width: 50px;
	height: 50px;
	border-radius: 5px;
	border: 1px solid #d5d5d5;
}
.product-subject label {
	display: inline-block;
	width: 300px;
	padding-left: 5px;
	vertical-align: top;
	white-space: pre-wrap;
}
</style>

<script type="text/javascript">
function searchList() {
	const f = document.searchForm;
	f.submit();
}

function changeList() {
	let parentNum = $("#changeCategory").val();
	let productShow = $("#changeShowProduct").val();
	
	const f = document.searchForm;
	f.parentNum.value = parentNum;
	f.categoryNum.value = 0;
	f.productShow.value = productShow;
	searchList();
}

function changeSubList() {
	let parentNum = $("#changeCategory").val();
	let categoryNum = $("#changeSubCategory").val();
	let productShow = $("#changeShowProduct").val();
	
	const f = document.searchForm;
	f.parentNum.value = parentNum;
	f.categoryNum.value = categoryNum;
	f.productShow.value = productShow;
	searchList();
}

// 탭
$(function(){
	$("button[role='tab']").on('click', function(){
		const tab = $(this).attr("aria-controls");
		
		if(tab === "1") { // 일반상품
			location.href="${pageContext.request.contextPath}/admin/product/100/main";
		} else if( tab === "2") { // 오늘의 특가
			location.href="${pageContext.request.contextPath}/admin/product/200/main";
		} else if( tab === "3") { // 기획상품
			location.href="${pageContext.request.contextPath}/admin/product/300/main";
		}
	});
});
</script>

<div class="container">
	<div class="body-container">
		<div class="body-title">
			<h3><i class="bi bi-app"></i> 상품관리 </h3>
		</div>
		
		<div class="body-main">
			<ul class="nav nav-tabs mt-5" id="myTab" role="tablist">
				<li class="nav-item" role="presentation">
					<button class="nav-link ${classify==100?'active':''}" id="tab-1" data-bs-toggle="tab" data-bs-target="#tab-pane" type="button" role="tab" aria-controls="1" aria-selected="${classify==0?'true':'false'}">일반상품</button>
				</li>
				<li class="nav-item" role="presentation">
					<button class="nav-link ${classify==200?'active':''}" id="tab-2" data-bs-toggle="tab" data-bs-target="#tab-pane" type="button" role="tab" aria-controls="2" aria-selected="${classify==1?'true':'false'}">특가상품</button>
				</li>
				<li class="nav-item" role="presentation">
					<button class="nav-link ${classify==300?'active':''}" id="tab-3" data-bs-toggle="tab" data-bs-target="#tab-pane" type="button" role="tab" aria-controls="3" aria-selected="${classify==2?'true':'false'}">기획상품</button>
				</li>
			</ul>
			
			<div class="tab-content pt-4" id="myTabContent">
				<div class="tab-pane fade show active" id="tab-pane" role="tabpanel" aria-labelledby="tab-1" tabindex="0">
					<div class="row mb-2">
						<div class="col">
							<div class="row text-end">
								<div class="col-auto pe-1">
									<select id="changeCategory" class="form-select" onchange="changeList();">
										<c:if test="${listCategory.size() == 0}">
											<option value="0">:: 메인카테고리 ::</option>
										</c:if>
										<c:forEach var="vo" items="${listCategory}">
											<option value="${vo.categoryNum}" ${parentNum==vo.categoryNum?"selected":""}>${vo.categoryName}</option>
										</c:forEach>
									</select>
								</div>
								<div class="col-auto pe-1">
									<select id="changeSubCategory" class="form-select" onchange="changeSubList();">
										<c:if test="${listSubCategory.size() == 0}">
											<option value="0">:: 카테고리 ::</option>
										</c:if>
										<c:forEach var="vo" items="${listSubCategory}">
											<option value="${vo.categoryNum}" ${categoryNum==vo.categoryNum?"selected":""}>${vo.categoryName}</option>
										</c:forEach>
									</select>
								</div>
								<div class="col-auto ps-1">
									<select id="changeShowProduct" class="form-select" onchange="changeList();">
										<option value="-1">:: 진열 여부 ::</option>
										<option value="1" ${productShow==1?"selected":""}>상품 진열</option>
										<option value="0" ${productShow==0?"selected":""}>상품 숨김</option>
									</select>						
								</div>
							</div>
						</div>
						<div class="col-auto pt-2 text-end">
							${dataCount}개(${page}/${total_page} 페이지)
						</div>
					</div>
					
					<table class="table table-border table-list">
						<thead>
							<tr class="border-top border-dark table-light">
								<th width="130">상품코드</th>
								<th>상품명</th>
								<th width="100">가격</th>
								<th width="60">할인율</th>
								<th width="60">재고</th>
								<th width="60">진열</th>
								<th width="80">수정일</th>
								<th width="120">변경</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="dto" items="${list}" varStatus="status">
								<tr valign="middle">
									<td>${dto.productNum}</td>
									<td class="product-subject left">
										<img src="${pageContext.request.contextPath}/uploads/product/${dto.thumbnail}">
										<a href="#"><label>${dto.productName}</label></a>
									</td>
									<td>${dto.price}</td>
									<td>${dto.discountRate}%</td>
									<td>${dto.totalStock}</td>
									<td>${dto.productShow==1?"표시":"숨김"}</td>
									<td>${dto.update_date}</td>
									<td>
										<c:url var="updateUrl" value="/admin/product/${classify}/update">
											<c:param name="productNum" value="${dto.productNum}"/>
											<c:param name="parentNum" value="${parentNum}"/>
											<c:param name="categoryNum" value="${categoryNum}"/>
											<c:param name="page" value="${page}"/>
										</c:url>
										<button type="button" class="btn border btn-productStock" data-productNum="${dto.productNum}" data-optionCount="${dto.optionCount}">재고</button>
										<button type="button" class="btn border" onclick="location.href='${updateUrl}';">수정</button>
									</td>
								</tr>					
							</c:forEach>
						</tbody>
					</table>

					<div class="page-navigation">
						${dataCount == 0 ? "등록된 상품이 없습니다." : paging}
					</div>
					
					<table class="table table-borderless">
						<tr>
							<td width="150">
								<button type="button" class="btn btn-light" onclick="location.href='${pageContext.request.contextPath}/admin/product/${classify}/main';"> <i class="bi bi-arrow-clockwise"></i> </button>				
							</td>
							<td align="center">
								<form class="row justify-content-center" name="searchForm" action="${pageContext.request.contextPath}/admin/product/${classify}/main" method="post">
									<div class="col-auto p-1">
										<select name="schType" class="form-select">
											<option value="all" ${schType=="all"?"selected":""}>상품명+설명</option>
											<option value="productNum" ${schType=="productNum"?"selected":""}>상품코드</option>
											<option value="productName" ${schType=="productName"?"selected":""}>상품명</option>
											<option value="content" ${schType=="content"?"selected":""}>설명</option>
										</select>
									</div>
									<div class="col-auto p-1">
										<input type="text" name="kwd" value="${kwd}" class="form-control">
										<input type="hidden" name="size" value="${size}">
										<input type="hidden" name="parentNum" value="${parentNum}">
										<input type="hidden" name="categoryNum" value="${categoryNum}">
										<input type="hidden" name="productShow" value="${productShow}">
									</div>
									<div class="col-auto p-1">
										<button type="button" class="btn btn-light" onclick="searchList()"> <i class="bi bi-search"></i> </button>
									</div>
								</form>
			
							</td>					
							<td width="150" align="right">
								<c:url var="url" value="/admin/product/${classify}/write"/>
								<button type="button" class="btn btn-light" onclick="location.href='${url}';">상품등록</button>
							</td>
						</tr>
					</table>
					
				</div>
			</div> <!-- tab-content _ end -->

		</div> <!-- body-main -->
	</div>
</div>

<!-- 재고 관리 대화상자  -->
<div class="modal fade" id="productStockDialogModal" tabindex="-1" aria-labelledby="productStockDialogModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="productStockDialogModalLabel">재고관리</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body pt-1">
				<div class="modal-productStock"></div>
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
	$('.btn-productStock').click(function(){
		// 재고 관리 대화상자
		let productNum = $(this).attr('data-productNum');
		let optionCount = $(this).attr('data-optionCount');
		let url = '${pageContext.request.contextPath}/admin/product/listProductStock?productNum='+productNum+'&optionCount='+optionCount;
		
		$('.modal-productStock').load(url);
		
		$('#productStockDialogModal').modal('show');
	});
	
	$('.modal-productStock').on('click', '.btn-allStockUpdate', function(){
		// 재고 일괄 변경
		if(! confirm('재고를 일괄 변경 하시겠습니까 ? ')) {
			return false;
		}
		
		let productNum = $(this).attr('data-productNum');
		let url = '${pageContext.request.contextPath}/admin/product/updateProductStock';
		let query = 'productNum='+productNum;
		
		let isValid = true;
		$('.productStcok-list tr').each(function(){
			let $input = $(this).find('input[name=totalStock]');
			let $btn = $(this).find('.btn-stockUpdate');
			
			if(!/^\d+$/.test($input.val().trim())) {
				alert('재고량은 숫자만 가능합니다.');
				$input.focus();
				isValid = false;
				return false;
			}
			
			let stockNum = $btn.attr('data-stockNum');
			let detailNum = $btn.attr('data-detailNum');
			detailNum = detailNum ? detailNum : 0;
			let detailNum2 = $btn.attr('data-detailNum2');
			detailNum2 = detailNum2 ? detailNum2 : 0;
			let totalStock = $input.val().trim();
			
			query += '&stockNums=' + stockNum;
			query += '&detailNums=' + detailNum;
			query += '&detailNums2=' + detailNum2;
			query += '&totalStocks=' + totalStock;
		});
		
		if( ! isValid ) {
			return false;
		}
		
		const fn = function(data) {
			if(data.state === "true") {
				alert("재고가 일괄 변경 되었습니다.");
			} else {
				alert("재고 일괄 변경이 실패 했습니다.");
			}
		};
		
		ajaxFun(url, "post", query, "json", fn);		
	});
	
	$('.modal-productStock').on('click', '.btn-stockUpdate', function(){
		// 재고 변경	
		let productNum = $(this).attr('data-productNum');
		let stockNum = $(this).attr('data-stockNum');
		let detailNum = $(this).attr('data-detailNum');
		detailNum = detailNum ? detailNum : 0;
		let detailNum2 = $(this).attr('data-detailNum2');
		detailNum2 = detailNum2 ? detailNum2 : 0;
		let totalStock = $(this).closest('tr').find('input[name=totalStock]').val().trim();
		
		if(!/^\d+$/.test(totalStock)) {
			alert('재고량은 숫자만 가능합니다.');
			$(this).closest('tr').find('input[name=totalStock]').focus();
			return false;
		}
	
		let url = '${pageContext.request.contextPath}/admin/product/updateProductStock';
		let query = {productNum:productNum, stockNums:stockNum, detailNums:detailNum, detailNums2:detailNum2, totalStocks:totalStock};
		
		const fn = function(data) {
			if(data.state === "true") {
				alert("재고가 변경 되었습니다.");
			} else {
				alert("재고 변경이 실패 했습니다.");
			}
		};
		
		ajaxFun(url, "post", query, "json", fn);		
		
	});
});

const productStockModalEl = document.getElementById('productStockDialogModal');
productStockModalEl.addEventListener('show.bs.modal', function(){
	// 모달 대화상자가 보일때
});

productStockModalEl.addEventListener('hidden.bs.modal', function(){
	// 모달 대화상자가 안보일때
	searchList();
});

</script>