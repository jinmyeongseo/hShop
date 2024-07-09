<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style type="text/css">
.body-container {
	max-width: 1000px;
}

.lg-img img { min-height: 420px; max-height: 420px;}
.md-img img { width: 150px; height: 150px; cursor: pointer; object-fit: cover; }
.sm-img img { width: 40px; height: 40px; cursor: pointer; object-fit: cover; }

.qty-plus, .qty-minus, .qty-remove { cursor: pointer; }
.qty-plus:hover, .qty-minus:hover, .qty-remove:hover { color: #0b83e6; }

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

.score-star { font-size: 0; letter-spacing: -4px; }
.score-star .item {
	font-size: 22px; letter-spacing: 1px; display: inline-block;
	color: #ccc; text-decoration: none; vertical-align: middle;
}
.score-star .item:first-child{ margin-left: 0; }
.score-star .on { color: #f54a4c; }

.graph { font-size: 0;  letter-spacing: 0; word-spacing: 0; }
.graph-title { padding-right: 3px; }
.graph .one-space { font-size:13px; background:#eee;}
.graph .one-space:after { content: ''; display: inline-block; width:17px; }
.graph .one-space.on{ background:  #f54a4c; }
.graph .one-space:first-child{ border-top-left-radius:5px;  border-bottom-left-radius:5px; }
.graph .one-space:last-child{ border-top-right-radius:5px; border-bottom-right-radius:5px; }
.graph-rate { padding-left: 5px; display: inline-block; width: 60px; text-align: left; }

.deleteReview, .notifyReview { cursor: pointer; padding-left: 5px; }
.deleteReview:hover, .notifyReview:hover { font-weight: 500; color: #2478FF; }

.qna-form textarea { width: 100%; height: 75px; resize: none; }
.qna-form .img-grid {
	display: grid;
	grid-template-columns:repeat(auto-fill, 54px);
	grid-gap: 2px;
}

.qna-form .img-grid .item {
	object-fit:cover;
	width: 50px; height: 50px; border-radius: 10px;
	border: 1px solid #c2c2c2;
	cursor: pointer;
}

.deleteQuestion, .notifyQuestion { cursor: pointer; padding-left: 5px; }
.deleteQuestion:hover, .notifyQuestion:hover { font-weight: 500; color: #2478FF; }

.product-content img { max-width: 1000px; }
</style>

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
</script>

<script type="text/javascript">
$(function(){
	const productNum = '${dto.productNum}';
	const optionCount = ${dto.optionCount};
	
	// 옵션이 없는 경우
	if(optionCount === 0) {
		let stockNum =  '${dto.stockNum}';
		let totalStock =  '${dto.totalStock}';
		let salePrice = ${dto.salePrice};
		$('.order-area').attr('data-totalStock', totalStock);
		
		buyQuantity(stockNum, salePrice, 0, 0);
	}
	
	// 옵션-1 선택
	$(".requiredOption").change(function(){
		let detailNum = $(this).val();
		if(! detailNum) {
			return false;
		}
		
		let optionNum = $(".requiredOption").attr("data-optionNum");
		
		// 옵션이 1개인 경우 ---
		if(optionCount === 1) {
			let b = true;
			$(".order-area input[name=detailNums]").each(function(){
				let dnum = $(this).val();
				if(detailNum === dnum) { // 선텍된 옵션 1인 경우
					b = false;
					return false;
				}
			});
			if(! b) {
				return false;
			}
			
			let stockNum =  $(".requiredOption :selected").attr("data-stockNum");
			let salePrice = ${dto.salePrice};
			
			buyQuantity(stockNum, salePrice, detailNum, 0);
			
			return false;
		}
		
		// 옵션이 2개인 경우 ---
		$(".requiredOption2 option").each(function(){
			if($(this).is(":first-child")) {
				return true; // continue
			}
			
        	$(this).remove();
        });
		
		let optionNum2 = $(".requiredOption2").attr("data-optionNum2");
		
		// 재고
		let url = "${pageContext.request.contextPath}/product/listOptionDetailStock";
		$.get(url, {productNum:productNum, detailNum:detailNum}, function(data){
			$(data).each(function(index, item){
				let detailNum = item.detailNum2;
				let optionValue = item.optionValue2;
				let stockNum = item.stockNum;
				let totalStock = parseInt(item.totalStock);
				
				let s;
				if(totalStock < 5) {
					s = "<option value='"+detailNum+"' data-optionValue='"+optionValue+"' data-stockNum='"+stockNum+"' data-totalStock='"+totalStock+"'>"+optionValue+" - 재고 "+totalStock+"</option>"
				} else {
					s = "<option value='"+detailNum+"' data-optionValue='"+optionValue+"' data-stockNum='"+stockNum+"' data-totalStock='"+totalStock+"'>"+optionValue+"</option>"
				}
				
				$(".requiredOption2").append(s);
			});
		});
	});
	
	// 옵션-2 선택
	$(".requiredOption2").change(function(){
		if(! $(this).val()) {
			return false;
		}

		let detailNum = $(".requiredOption").val();
		let detailNum2 = $(this).val();
		
		let b = true;
		$(".order-area input[name=detailNums2]").each(function(){
			let dnum = $(this).closest(".input-group").find("input[name=detailNums]").val();
			let dnum2 = $(this).val();
			if(detailNum === dnum && detailNum2 === dnum2) {
				alert("선택된 옵션입니다.");
				$(".requiredOption").val("");
				$(".requiredOption").trigger("change");
				b = false;
				return false;
			}
		});
		if(! b) {
			return false;
		}
		
		let stockNum = $(".requiredOption2 :selected").attr("data-stockNum");
		let salePrice = ${dto.salePrice};
		
		buyQuantity(stockNum, salePrice, detailNum, detailNum2);
	});
	
	// 구매 개수 객체
	function buyQuantity(stockNum, salePrice, detailNum, detailNum2) {
		let totalPrice = salePrice.toLocaleString();
		
		let optionValue = '', optionValue2 = '';
		let buyOption = '';
		
		if(optionCount === 1) {
			optionValue = $('.requiredOption :selected').attr('data-optionValue');
			buyOption = optionValue;
		} else if(optionCount === 2) {
			optionValue = $('.requiredOption :selected').text();
			optionValue2 = $('.requiredOption2 :selected').attr('data-optionValue');
			buyOption = optionValue + ' / ' + optionValue2;
		}
		
		let out = '';
		out += '<div class="order-qty">';
		if(optionCount > 0) {
			out += '  <div class="mt-2 pb-1">';
			out += '    <label>' + buyOption + '</label>';
			out += '  </div>';
		}
		out += '  <div class="row border-bottom mt-1 pb-2">';
		out += '    <div class="col">';
		out += '      <div class="input-group">';
		out += '        <i class="bi bi-dash input-group-text bg-white qty-minus"></i>';
		out += '        <input type="text" name="buyQtys" class="form-control" value="1" style="flex:none; width: 60px; text-align: center;" readonly>';
		out += '        <input type="hidden" name="productNums" value="' + productNum + '">';
		out += '        <input type="hidden" name="stockNums" value="' + stockNum + '">';
		out += '        <input type="hidden" name="detailNums" value="' + detailNum + '" disabled>';
		out += '        <input type="hidden" name="detailNums2" value="' + detailNum2 + '" disabled>';
		out += '        <i class="stockNumsbi bi-plus input-group-text bg-white qty-plus"></i>';
		out += '      </div>';
		out += '    </div>';
		out += '    <div class="col text-end product-salePrice" data-salePrice="' + salePrice + '">';
		out += '      <label class="pt-2 fs-6 fw-semibold item-totalPrice">' + totalPrice + '원</label>';
		if(optionCount > 0) {
			out += '      <label class="pt-2 ps-1"><i class="bi bi-x qty-remove"></i></label>';
		}
		out += '    </div>';
		out += '  </div>';
		out += '</div>';
		
		$('.order-area').append(out);
		
		totalProductPrice();
	}

	// 수량 더하기
	$(".order-area").on("click", ".qty-plus", function() {
		let totalStock = 0;
		if(optionCount === 0) {
			totalStock = parseInt($(".order-area").attr("data-totalStock"));
		} else if(optionCount === 1) {
			totalStock = parseInt($(".requiredOption :selected").attr("data-totalStock"));
		} else if(optionCount === 2) {
			totalStock = parseInt($(".requiredOption2 :selected").attr("data-totalStock"));
		}
		
		let $order = $(this).closest(".order-qty");
		let qty = parseInt($order.find("input[name=buyQtys]").val());
		
		if(qty >= totalStock) {
			alert("재고가 부족합니다.");
			return false;
		}
		
		qty++;
		$order.find("input[name=buyQtys]").val(qty);
		let salePrice = $order.find(".product-salePrice").attr("data-salePrice");
		let item = qty * salePrice;
		let totalPrice = item.toLocaleString();
		$order.find(".item-totalPrice").text(totalPrice+"원");
		
		totalProductPrice();
	});

	// 수량 빼기
	$(".order-area").on("click", ".qty-minus", function() {
		let $order = $(this).closest(".order-qty");
		let qty = parseInt($order.find("input[name=buyQtys]").val()) - 1;
		if(qty <= 0) {
			alert("구매 수량은 한개 이상입니다.");
			if(optionCount === 0) {
				return false;			
			}
			
			$(".requiredOption").val("");
			$(".requiredOption").trigger("change");
			$order.remove();
			
			totalProductPrice()
			
			return false;
		}
		
		$order.find("input[name=buyQtys]").val(qty);
		let salePrice = $order.find(".product-salePrice").attr("data-salePrice");
		let item = qty * salePrice;
		let totalPrice = item.toLocaleString();
		$order.find(".item-totalPrice").text(totalPrice+"원");
		
		totalProductPrice();
	});
	
	// 수량 제거
	$(".order-area").on("click", ".qty-remove", function() {
		if(optionCount === 0) {
			return false;			
		}
		
		let $order = $(this).closest(".order-qty");
		$(".requiredOption").val("");
		$(".requiredOption").trigger("change");
		$order.remove();
		
		totalProductPrice();
	});
	
	function totalProductPrice() {
		let totalQty = 0;
		let totalPrice = 0;
		$(".order-qty").each(function(){
			let qty = parseInt($(this).find("input[name=buyQtys]").val());
			let salePrice = parseInt($(this).find(".product-salePrice").attr("data-salePrice"));
			
			totalQty += qty;
			totalPrice += (salePrice * qty);
		});
		
		let s = totalPrice.toLocaleString();
		
		$(".product-totalQty").text(totalQty);
		$(".product-totalAmount").text(s);
	}
});

$(function(){
	$(".sm-img img").click(function(){
		let url = $(this).attr("src");
		$(".lg-img img").attr("src", url);
	});
});

function sendOk(mode) {
	let totalQty = 0;
	$(".order-qty").each(function(){
		let qty = parseInt($(this).find("input[name=buyQtys]").val());
		
		totalQty += qty;
	});
	
	if(totalQty <= 0) {
		alert("구매 상품의 수량을 선택하세요 !!! ");
		return;
	}

	const f = document.buyForm;
	if(mode === "buy") {
		// GET 방식으로 전송. 로그인후 결제화면으로 이동하기 위해
		// 또는 자바스크립트 sessionStorage를 활용 할 수 있음
		f.method = "get";
		f.action = "${pageContext.request.contextPath}/order/payment";
	} else {
		if(! confirm("선택한 상품을 장바구니에 담으시겠습니까 ? ")) {
			return false;
		}
		
		f.method = "post";
		f.action = "${pageContext.request.contextPath}/myPage/saveCart";
	}
	
	f.submit();
}

// 오늘본 상품 목록
$(function(){
	let pnum = "${dto.productNum}";
	let pname = "${dto.productName}";
	let pimg = "${dto.thumbnail}";
	
	// localStorage.clear(); // localStorage 전체 지우기
	
	let product = JSON.parse(localStorage.getItem("product")) || [];
	
	// 동일한 상품이면 삭제
	product.forEach(function(data){
		if(data.pnum === pnum) {
			let idx = product.indexOf(data);
			if(idx > -1) product.splice(idx, 1);
			return;
		}
	});
	/*
	// 필터를 사용한 경우
	let result = product.filter(function(item, index, self){
		return pnum != item.pnum;
	});
	product = result;
	*/
	
	// 9개 이상이면 마지막 데이터 삭제
	if(product.length >= 9) {
		product.splice(product.length-1, 1);
	}
	
	// 저장할 데이터
	let obj = {pnum:pnum, pname:pname, pimg:pimg};
	product.unshift(obj); // 배열 가장 앞에 추가
	
	// 웹스트로지에 저장
	let p = JSON.stringify(product);
	localStorage.setItem("product", p);
});

// 오늘의 특가 / 기획전 남은 시간 계산
function task() {
	let endDate = "${dto.endDate}";
	if(! endDate) return false;
	
    let y = parseInt(endDate.substring(0, 4));
    let m = parseInt(endDate.substring(5, 7));
    let d = parseInt(endDate.substring(8, 10));
    let h = parseInt(endDate.substring(11, 13));
    let mi = parseInt(endDate.substring(14));
	
	let now = new Date();
	let date = new Date(y, m-1, d, h, mi, 0);
	
	let diff = Math.floor((date.getTime() - now.getTime()) / 1000);
	if(diff <= 0) {
		$(".btn-buySend").prop("disabled", true);
		$(".btn-productBlind").prop("disabled", true);
		$(".btn-productCart").prop("disabled", true);
		$(".time-remaining").html("판매 종료");
		
		return false;
	}
	
	let days = Math.floor(diff / (24*3600));
	let hours = Math.floor((diff % (24*3600)) / 3600);
	if (hours < 10) hours = "0" + hours;
	let minutes = Math.floor((diff % (3600)) / 60);
	if (minutes < 10) minutes = "0" + minutes;
	let seconds = Math.floor(diff % 60);
	if (seconds < 10) seconds = "0" + seconds;

    let s = "";
    if(days >= 1) s = days + "일 "
    
    s += hours + ":" + minutes + ":" + seconds +" 남음";
    $(".time-remaining").html(s);
    
    setTimeout("task();", 1000);
}

$(function(){
	let classify = "${dto.classify}";
	if(classify === "0") return false;
	
	task();
});
</script>

<div class="container">
	<div class="body-container">	
		<div class="body-main">
			<div class="row mt-4">
				<div class="col-md-6 border border-end-0 pt-2">
					<div class="row gx-1 border rounded">
						<div class="col lg-img">
							<img class="w-100 h-100" src="${pageContext.request.contextPath}/uploads/product/${dto.thumbnail}">
						</div>
					</div>
					<div class="row gx-1 mt-2 p-1">
						<c:forEach var="vo" items="${listFile}">
							<div class="col-md-auto sm-img">
								<img class="border rounded" src="${pageContext.request.contextPath}/uploads/product/${vo.filename}">
							</div>
						</c:forEach>
					</div>
				</div>
				
				<div class="col-md-6 border">
					<form name="buyForm">
						<c:if test="${dto.totalStock < 1}">
							<div class="border rounded bg-light mt-2 p-2 text-center">
								<label class="text-black-50 fw-bold">상품 재고가 없습니다.</label>
							</div>
						</c:if>
					
						<c:if test="${dto.totalStock > 0 && dto.classify != 100}">
							<div class="border rounded bg-light mt-2 p-2">
								<label class="fs-6 fw-semibold text-primary pe-2">${dto.classify == 200 ? "오늘의 특가" : "기획전"}</label>
								<label class="fs-6 fw-semibold pe-2 time-remaining">1일 10시간 남음</label>
								<label class="text-black-50"><fmt:formatNumber value="${dto.saleCount}"/>개 구매</label>
							</div>
						</c:if>
						
						<div class="row pt-2">
							<div class="col fs-4 fw-semibold">
								${dto.productName}
							</div>
						</div>
						
						<div class="row pt-1 pb-1 border-bottom">
							<div class="col">
								<label class="align-middle">리뷰수 <span class="fs-5 fw-semibold product-reviewCount">${dto.reviewCount}</span></label>
								<label class="align-middle pt-0 ps-2 score-star product-star">
									<c:forEach var="n" begin="1" end="5">
										<c:set var="score" value="${dto.score + ((dto.score%1>=0.5) ? (1-dto.score%1)%1 : -(dto.score%1))}"/>
										<span class="fs-6 item ${score>=n?'on':''}"><i class="bi bi-star-fill"></i></span>
									</c:forEach>
								</label>
								<label class="align-middle "><span class="product-score ps-1">(${dto.score} / 5)</span></label>
							</div>
						</div>
						
						<div class="row mt-2">
							<c:if test="${dto.discountRate != 0}">
								<div class="col-auto fs-5 pe-2 text-danger">${dto.discountRate}%</div>
							</c:if>
							<div class="col text-end">
								<label class="fs-5 pe-2 fw-semibold">
									<fmt:formatNumber value="${dto.salePrice}"/>원
								</label>
								<c:if test="${dto.discountRate != 0}">
									<label class="fs-6 fw-light text-decoration-line-through">
										<fmt:formatNumber value="${dto.price}"/>원
									</label>
								</c:if>
							</div>
						</div>
						
						<div class="row border p-2 m-1 mt-2">
							<div class="col">
								<div class="border-bottom p-2 fs-6 fw-semibold">회원을 위한 혜택</div>
								<div class="row p-2">
									<div class="col-auto text-black-50">적립 포인트</div>
									<div class="col fs-6 text-end">${dto.savedMoney}</div>
								</div>
								<div class="row ps-2 pe-2">
									<div class="col-auto text-black-50">쿠폰 사용 | 포인트 결제</div>
								</div>
							</div>
						</div>

						<div class="border-bottom mt-2 text-black-50 pb-2">
							무이자 할부 | 카드 자세히 보기 <i class="bi bi-question-circle"></i>
						</div>

						<div class="border-bottom mt-2 pb-2">
							<div>
								<label>택배 배송 | </label> 
								<label>
									<c:choose>
										<c:when test="${dto.delivery==0}">무료 배송</c:when>
										<c:otherwise>
											<fmt:formatNumber value="${dto.delivery}"/>
										</c:otherwise>
									</c:choose>
								</label>
								<label>(주문시 결제)</label>
							</div>
							<div>
								<label>제주 추가 배송비 3,000 / 제주 제외 도서 산간 추가 배송비 5,000</label>
							</div>
							<div>
								<label>200,000 이상 구매시 무료</label>
							</div>
						</div>
						
						<c:if test="${dto.optionCount > 0}">
							<div class="mt-2">
								* 필수 옵션
							</div>
						</c:if>
						
						<c:if test="${dto.optionCount > 0}">
							<div class="mt-2">
								<select class="form-select requiredOption" data-optionNum="${listOption[0].optionNum}" ${dto.totalStock < 1 ? 'disabled':''}>
									<option value="">${listOption[0].optionName}</option>
									<c:forEach var="vo" items="${listOptionDetail}">
										<c:if test="${dto.optionCount == 1}">
											<option value="${vo.detailNum}" data-stockNum="${vo.stockNum}" data-totalStock="${vo.totalStock}" data-optionValue="${vo.optionValue}">${vo.optionValue}${vo.totalStock<5?' 재고 - '+= vo.totalStock:''}</option>
										</c:if>
										<c:if test="${dto.optionCount != 1}">
											<option value="${vo.detailNum}">${vo.optionValue}</option>
										</c:if>
									</c:forEach>
								</select>
							</div>
						</c:if>
	
						<c:if test="${dto.optionCount > 1}">
							<div class="mt-2 border-bottom pb-2">
								<select class="form-select requiredOption2" data-optionNum2="${listOption[1].optionNum}" ${dto.totalStock < 1 ? 'disabled':''}>
									<option value="">${listOption[1].optionName}</option>
								</select>
							</div>
						</c:if>
						
						<div class="order-area">
						</div>
						
						<div class="row mt-2 pb-2">
							<div class="col-auto fw-semibold pt-1">총상품금액</div>
							<div class="col text-end">
								<label>총수량 <span class="product-totalQty">0</span>개 | </label>
								<label><span class="product-totalAmount fs-5 fw-semibold text-primary">0</span>원</label>
							</div>
						</div>
	
						<div class="mt-2">
							<input type="hidden" name="mode" value="buy">
							<button type="button" class="btn btn-primary w-100 btn-buySend" onclick="sendOk('buy');" ${dto.totalStock < 1 ? 'disabled':''}>구매하기</button>
						</div>
						<div class="row mt-2 mb-2">
							<div class="col pe-1">
								<button type="button" class="btn border w-100 btn-productBlind" ${empty sessionScope.member.memberIdx ? "disabled='disabled'" : ""}>찜하기 <i class="bi bi-heart"></i></button>
							</div>
							<div class="col ps-1">
								<button type="button" class="btn border w-100 btn-productCart" onclick="sendOk('cart');" ${empty sessionScope.member.memberIdx || dto.totalStock < 1 ? "disabled='disabled'" : ""}>장바구니 <i class="bi bi-bag"></i></button>
							</div>
						</div>
					</form>
				</div>
			</div>
			<div class="mt-2 mb-2 text-end">
				<label><i class="bi bi-exclamation-octagon"></i> 팁</label>
				<label class="text-danger">안전거래 </label>
			</div>


			<ul class="nav nav-tabs mt-5" id="myTab" role="tablist">
				<li class="nav-item" role="presentation">
					<button class="nav-link active" id="tab-1" data-bs-toggle="tab" data-bs-target="#tab-pane-1" type="button" role="tab" aria-controls="1" aria-selected="true">상세정보</button>
				</li>
				<li class="nav-item" role="presentation">
					<button class="nav-link" id="tab-2" data-bs-toggle="tab" data-bs-target="#tab-pane-2" type="button" role="tab" aria-controls="2" aria-selected="false">리뷰 <span class="title-reviewCount">(${dto.reviewCount})</span></button>
				</li>
				<li class="nav-item" role="presentation">
					<button class="nav-link" id="tab-3" data-bs-toggle="tab" data-bs-target="#tab-pane-3" type="button" role="tab" aria-controls="3" aria-selected="false">문의사항 <span class="title-qnaCount">(${dto.questionCount})</span></button>
				</li>
				<li class="nav-item" role="presentation">
					<button class="nav-link" id="tab-4" data-bs-toggle="tab" data-bs-target="#tab-pane-4" type="button" role="tab" aria-controls="4" aria-selected="false">배송 및 환불정책</button>
				</li>
			</ul>
			
			<div class="tab-content pt-2" id="myTabContent">
				<div class="tab-pane fade show active" id="tab-pane-1" role="tabpanel" aria-labelledby="tab-1" tabindex="0">
					<div class="mt-3 pt-3 border-bottom">
						<p class="fs-4 fw-semibold">${dto.productName}</p> 
					</div>
					<div class="mt-3 product-content">
						${dto.content}
					</div>
				</div>
				<div class="tab-pane fade" id="tab-pane-2" role="tabpanel" aria-labelledby="tab-2" tabindex="0">
					<div class="mt-3 pt-3 border-bottom">
						<p class="fs-4 fw-semibold">상품 리뷰</p> 
					</div>

					<div class="row border-bottom">
						<div class="col p-3 text-center">
							<div class="fs-6 fw-semibold">상품만족도</div>
							<div class="score-star review-score-star">
								<c:forEach var="n" begin="1" end="5">
									<c:set var="score" value="${dto.score + ((dto.score%1>=0.5) ? (1-dto.score%1)%1 : -(dto.score%1))}"/>
									<span class="item fs-2 ${dto.score>=n?'on':''}"><i class="bi bi-star-fill"></i></span>
								</c:forEach>
							</div>
							<div class="fs-2">
								<label class="review-score">${dto.score} / 5</label> 
							</div>
						</div>
						
						<div class="col p-3 text-center">
							<div class="fs-6 fw-semibold">리뷰수</div>
							<div class="fs-2"><i class="bi bi-chat-right-text"></i></div>
							<div class="fs-2 review-reviewCount">${dto.reviewCount}</div>
						</div> 
						
						<div class="col p-3 text-center review-rate">
							<div class="fs-6 fw-semibold">평점비율</div>
							<div class="p-1 score-5">
								<span class="graph-title">5점</span>
								<span class="graph">
									<c:forEach var="n" begin="1" end="10">
										<label class="one-space"></label>
									</c:forEach>
								</span>
								<span class="graph-rate">0%</span>
							</div>
							<div class="p-1 score-4">
								<span class="graph-title">4점</span>
								<span class="graph">
									<c:forEach var="n" begin="1" end="10">
										<label class="one-space"></label>
									</c:forEach>
								</span>
								<span class="graph-rate">0%</span>
							</div>
							<div class="p-1 score-3">
								<span class="graph-title">3점</span>
								<span class="graph">
									<c:forEach var="n" begin="1" end="10">
										<label class="one-space"></label>
									</c:forEach>
								</span>
								<span class="graph-rate">0%</span>
							</div>
							<div class="p-1 score-2">
								<span class="graph-title">2점</span>
								<span class="graph">
									<c:forEach var="n" begin="1" end="10">
										<label class="one-space"></label>
									</c:forEach>
								</span>
								<span class="graph-rate">0%</span>
							</div>
							<div class="p-1 score-1">
								<span class="graph-title">1점</span>
								<span class="graph">
									<c:forEach var="n" begin="1" end="10">
										<label class="one-space"></label>
									</c:forEach>
								</span>
								<span class="graph-rate">0%</span>
							</div>
						</div>
					</div>

					<div class="row mt-3 reviewSort-area">
						<div class="col">&nbsp;</div>
						<div class="col-auto text-end">
							<select class="form-select reviewSortNo">
								<option value="0"> 출력 순서 </option>
								<option value="1"> 최신 글 </option>
								<option value="2"> 평점 높은순 </option>
								<option value="3"> 평점 낮은순 </option>
							</select>
						</div>
					</div>
					
					<div class="mt-2 list-review"></div>
				</div>
				
				<div class="tab-pane fade" id="tab-pane-3" role="tabpanel" aria-labelledby="tab-3" tabindex="0">
					<div class="mt-3 pt-3 border-bottom">
						<p class="fs-4 fw-semibold">상품 문의 사항</p> 
					</div>
			
					<div class="mt-3 p-2 text-end">
						<button type="button" class="btnMyQuestion btn btn-dark" ${empty sessionScope.member ? "disabled":""}> 내 Q&amp;A 보기  </button>
						<button type="button" class="btnQuestion btn btn-dark" ${empty sessionScope.member ? "disabled":""}> 상품 Q&amp;A 작성 </button>
					</div>
					<div class="mt-1 p-2 list-question"></div>
										
				</div>
				
				<div class="tab-pane fade" id="tab-pane-4" role="tabpanel" aria-labelledby="tab-4" tabindex="0">
					<div class="mt-3 pt-3 border-bottom">
						<p class="fs-4 fw-semibold">배송 및 환불정책</p> 
					</div>
					<div class="mt-3">
						<p> 배송 및 환불 정책 입니다. </p>
					</div>				
				</div>
			</div>

		</div>
	</div>
</div>

<div class="modal fade" id="questionDialogModal" tabindex="-1" 
		data-bs-backdrop="static" data-bs-keyboard="false"
		aria-labelledby="questionDialogModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="questionDialogModalLabel">상품 문의 하기</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">

				<div class="qna-form p-2">
					<form name="questionForm">
						<div class="row">
							<div class="col">
								<span class="fw-bold">문의사항 쓰기</span><span> - 상품 및 상품 구매 과정과 관련없는 글은 삭제 될 수 있습니다.</span>
							</div>
							<div class="col-3 text-end">
								<input type="checkbox" name="secret" id="secret1" class="form-check-input" 
									value="1">
								<label class="form-check-label" for="secret1">비공개</label>
							</div>
						</div>
						<div class="p-1">
							<input type="hidden" name="productNum" value="${dto.productNum}">
							<textarea name="question" id="question" class="form-control"></textarea>
						</div>
						<div class="p-1">
							<div class="img-grid">
								<img class="item img-add" src="${pageContext.request.contextPath}/resources/images/add_photo.png">
							</div>
							<input type="file" name="selectFile" accept="image/*" multiple class="form-control" style="display: none;">
						</div>							
					</form>
				</div>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary btnQuestionSendOk">문의등록 <i class="bi bi-check2"></i> </button>
				<button type="button" class="btn btn-secondary btnQuestionSendCancel" data-bs-dismiss="modal">취소</button>
			</div>			
		</div>
	</div>
</div>

<script type="text/javascript">
// 탭 -----
$(function(){
	$("button[role='tab']").on('click', function(){
		const tab = $(this).attr("aria-controls");
		
		if(tab === "2") { // review
			listReview(1);
		} else if( tab === "3") { // qna
			listQuestion(1);
		}
	});
});

// 리뷰 -----
$(function(){
	$('.reviewSortNo').change(function(){
		listReview(1);
	});
});

function listReview(page) {
	let productNum = '${dto.productNum}';
	let sortNo = $('.reviewSortNo').val();
	let url = '${pageContext.request.contextPath}/review/list';
	let query = 'productNum='+productNum+'&pageNo='+page+'&sortNo='+sortNo;
	
	const fn = function(data) {
		printReview(data);
	};
	ajaxFun(url, 'get', query, 'json', fn);
}
 
function printReview(data) {
	let dataCount = data.dataCount;
	let pageNo = data.pageNo;
	let total_page = data.total_page;
	let size = data.size;
	let paging = data.paging;
	
	if(dataCount > 0) {
		$('.reviewSort-area').show();
	} else {
		$('.reviewSort-area').hide();
	}
	
	let summary = data.summary;
	printSummary(summary);
	
	let out = '';
	for(let item of data.list) {
		let num = item.num;
		let userName = item.userName;
		let score = item.score;
		let review = item.review;
		let review_date = item.review_date;
		let answer = item.answer;
		let answer_date = item.answer_date;
		let listFilename = item.listFilename;
		// let deletePermit = item.deletePermit;

		out += '<div class="mt-3 border-bottom">';
		out += '  <div class="row p-2">';
		out += '     <div class="col-auto fs-2"><i class="bi bi-person-circle text-muted icon"></i></div>';
		out += '     <div class="col pt-3 ps-0 fw-semibold">'+userName+'</div>';
		out += '     <div class="col pt-3 text-end"><span>'+review_date+'</span>';
		out += '       |<span class="notifyReview" data-num="' + num + '">신고</span></div>';
		out += '  </div>';
		out += '  <div class="row p-2">';
		out += '    <div class="col-auto pt-0 ps-2 pe-1 score-star">';
		for(let i=1; i<=5; i++) {
			out += '  <span class="item fs-6 ' + (score>=i ? 'on' : '') + '"><i class="bi bi-star-fill"></i></span>';
		}
		out += '    </div>';
		out += '    <div class="col-auto ps-0 fs-6"><span>' + score + '점<span></div>';
		out += '  </div>';
		out += '  <div class="mt-2 p-2">' + review + '</div>';

		if(listFilename && listFilename.length > 0) {
			out += '<div class="row gx-1 mt-2 mb-1 p-1">';
				for(let f of listFilename) {
					out += '<div class="col-md-auto md-img">';
					out += '  <img class="border rounded" src="${pageContext.request.contextPath}/uploads/review/'+f+'">';
					out += '</div>';
				}
			out += '</div>';
		}
		
		if(answer) {
			out += '  <div class="p-3 pt-0">';
			out += '    <div class="bg-light">';
			out += '      <div class="p-3 pb-0">';
			out += '        <label class="text-bg-primary px-2"> 관리자 </label> <label>' + answer_date + '</label>';
			out += '      </div>';
			out += '      <div class="p-3 pt-1">' + answer + '</div>';
			out += '    </div>';
			out += '  </div>';
		}
		out += '</div>';
	}
	if(dataCount > 0) {
		out += '<div class="page-navigation">' + paging + '</div>';
	}
	
	$('.list-review').html(out);
}

function printSummary(summary) {
	let count = summary.count;
	let ave = summary.ave;
	
	let score1 = summary.score1;
	let score2 = summary.score2;
	let score3 = summary.score3;
	let score4 = summary.score4;
	let score5 = summary.score5;
	let scoreRate1 = summary.scoreRate1;
	let scoreRate2 = summary.scoreRate2;
	let scoreRate3 = summary.scoreRate3;
	let scoreRate4 = summary.scoreRate4;
	let scoreRate5 = summary.scoreRate5;
	
	$(".product-reviewCount").text(count);
	$(".product-score").text("("+ave+" / 5)");
	$(".product-star .item").removeClass("on");
	let roundAve = Math.round(ave);
	for(let i=1; i<=roundAve; i++) {
		$(".product-star .item").eq(i-1).addClass("on");
	}
	
	$(".title-reviewCount").text("("+count+")");
	
	$(".review-score-star .item").removeClass("on");
	for(let i=1; i<=roundAve; i++) {
		$(".review-score-star .item").eq(i-1).addClass("on");
	}
	$(".review-score").text(ave+" / 5");
	$(".review-reviewCount").text(count);
	
	$(".review-rate .one-space").removeClass("on");

	for(let i=1; i<=Math.floor(scoreRate5/10); i++) {
		$(".review-rate .score-5 .one-space").eq(i-1).addClass("on");
	}
	$(".review-rate .score-5 .graph-rate").text(scoreRate5+"%");
	
	for(let i=1; i<=Math.floor(scoreRate4/10); i++) {
		$(".review-rate .score-4 .one-space").eq(i-1).addClass("on");
	}
	$(".review-rate .score-4 .graph-rate").text(scoreRate4+"%");

	for(let i=1; i<=Math.floor(scoreRate3/10); i++) {
		$(".review-rate .score-3 .one-space").eq(i-1).addClass("on");
	}
	$(".review-rate .score-3 .graph-rate").text(scoreRate3+"%");

	for(let i=1; i<=Math.floor(scoreRate2/10); i++) {
		$(".review-rate .score-2 .one-space").eq(i-1).addClass("on");
	}
	$(".review-rate .score-2 .graph-rate").text(scoreRate2+"%");

	for(let i=1; i<=Math.floor(scoreRate1/10); i++) {
		$(".review-rate .score-1 .one-space").eq(i-1).addClass("on");
	}
	$(".review-rate .score-1 .graph-rate").text(scoreRate1+"%");
}

$(function(){
	$('body').on('click', '.notifyReview', function(){
		let num = $(this).attr('data-num');
		alert(num);
	});
});

// question -----
function listQuestion(page) {
	let productNum = '${dto.productNum}';
	let url = '${pageContext.request.contextPath}/qna/list';
	let query = 'productNum='+productNum+'&pageNo='+page;
	
	const fn = function(data) {
		printQuestion(data);
	};
	ajaxFun(url, 'get', query, 'json', fn);
}

function printQuestion(data) {
	let dataCount = data.dataCount;
	let pageNo = data.pageNo;
	let total_page = data.total_page;
	let size = data.size;
	let paging = data.paging;
	
	$('.title-qnaCount').html('(' + dataCount + ')');
	let out = '';
	for(let item of data.list) {
		let num = item.num;
		let userName = item.userName;
		let question = item.question;
		let question_date = item.question_date;
		let answer = item.answer;
		let answer_date = item.answer_date;
		let answerState = answer_date ? '<span class="text-primary">답변완료</span>' : '<span class="text-secondary">답변대기</span>';
		let listFilename = item.listFilename;
		let secret = item.secret;

		out += '<div class="mt-1 border-bottom">';
		out += '  <div class="mt-2 p-2">' + question + '</div>';

		if(listFilename && listFilename.length > 0) {
			out += '<div class="row gx-1 mt-2 mb-1 p-1">';
				for(let f of listFilename) {
					out += '<div class="col-md-auto md-img">';
					out += '  <img class="border rounded" src="${pageContext.request.contextPath}/uploads/qna/'+f+'">';
					out += '</div>';
				}
			out += '</div>';
		}
		out += '  <div class="row p-2">';
		out += '     <div class="col-auto pt-2 pe-0">' + answerState + '</div>';
		out += '     <div class="col-auto pt-2 px-0">&nbsp;|&nbsp;'+userName+'</div>';
		out += '     <div class="col-auto pt-2 px-0">&nbsp;|&nbsp;<span>'+question_date+'</span>';
		if(secret === 0) {
			out += '       |<span class="notifyQuestion" data-num="' + num + '">신고</span>';
		}
		out += '      </div>';
		if(answer) {
			out += '  <div class="col pt-2 text-end"><button class="btn btnAnswerView"> <i class="bi bi-chevron-down"></i> </button></div>';
		}
		out += '  </div>';
		if(answer) {
			out += '  <div class="p-3 pt-0 answer-content" style="display: none;">';
			out += '    <div class="bg-light">';
			out += '      <div class="p-3 pb-0">';
			out += '        <label class="text-bg-primary px-2"> 관리자 </label> <label>' + answer_date + '</label>';
			out += '      </div>';
			out += '      <div class="p-3 pt-1">' + answer + '</div>';
			out += '    </div>';
			out += '  </div>';
		}
		out += '</div>';
	}
	
	if(dataCount > 0) {
		out += '<div class="page-navigation">' + paging + '</div>';
	}

	$('.list-question').html(out);
}

$(function(){
	$('.list-question').on('click', '.btnAnswerView', function(){
		const $btn = $(this);
		const $EL = $(this).closest('.row').next('.answer-content');
		if($EL.is(':visible')) {
			$btn.html(' <i class="bi bi-chevron-down"></i> ');
			$EL.hide(100);
		} else {
			$btn.html(' <i class="bi bi-chevron-up"></i> ');
			$EL.show(100);
		}
	});
});

$(function(){
	var sel_files = [];
	
	$("body").on("click", ".qna-form .img-add", function(){
		$(this).closest(".qna-form").find("input[name=selectFile]").trigger("click");
	});
	
	$("form[name=questionForm] input[name=selectFile]").change(function(e){
		if(! this.files) {
			let dt = new DataTransfer();
			for(let f of sel_files) {
				dt.items.add(f);
			}
			
			this.files = dt.files;
			
			return false;
		}
		
		let $form = $(this).closest("form");
		
		// 유사 배열을  배열로 변환
		const fileArr = Array.from(this.files);
		
		fileArr.forEach((file, index) => {
			sel_files.push(file);
			
			const reader = new FileReader();
			const $img = $("<img>", {"class":"item img-item"});
			$img.attr("data-filename", file.name);
			reader.onload = e => {
				$img.attr("src", e.target.result);		
			};
			reader.readAsDataURL(file);
			$form.find(".img-grid").append($img);
		});
		
		let dt = new DataTransfer();
		for(let f of sel_files) {
			dt.items.add(f);
		}
		
		this.files = dt.files;
	});
	
	$("body").on("click", ".qna-form .img-item", function(){
		if(! confirm("선택한 파일을 삭제 하시겠습니까 ? ")) {
			return false;
		}
		
		let filename = $(this).attr("data-filename");
		
		for(let i=0; i<sel_files.length; i++) {
			if(filename === sel_files[i].name) {
				sel_files.splice(i, 1);
				break;
			}
		}
		
		let dt = new DataTransfer();
		for(let f of sel_files) {
			dt.items.add(f);
		}
		
		const f = this.closest("form");
		f.selectFile.files = dt.files;
		
		$(this).remove();
	});
	
	$('.btnQuestion').click(function(){
		$("#questionDialogModal").modal("show");
	});

	$('.btnQuestionSendOk').click(function(){
		const f = document.questionForm;
		let s;
		
		s = f.question.value.trim();
		if( ! s ) {
			alert("문의 사항을 입력하세요.")	;
			f.question.focus();
			return false;
		}
		
		if(f.selectFile.files.length > 5) {
			alert("이미지는 최대 5개까지 가능합니다..")	;
			return false;
		}
		
		let url = "${pageContext.request.contextPath}/qna/write";
		// FormData : form 필드와 그 값을 나타내는 일련의 key/value 쌍을 쉽게 생성하는 방법을 제공 
		// FormData는 Content-Type을 명시하지 않으면 multipart/form-data로 전송
		let query = new FormData(f); 
		
		const fn = function(data) {
			if(data.state === "true") {
				f.reset();
				$(".qna-form .img-item").each(function(){
					$(this).remove();
				});
				sel_files.length = 0;
				
				$("#questionDialogModal").modal("hide");
				
				listQuestion(1);
			}
		};
		
		ajaxFun(url, "post", query, "json", fn, true);
	});
	
	$('.btnQuestionSendCancel').click(function(){
		const f = document.questionForm;
		f.reset();
		$(".qna-form .img-item").each(function(){
			$(this).remove();
		});
		sel_files.length = 0;
		
		$("#questionDialogModal").modal("hide");
	});	
	
	$('.btnMyQuestion').click(function(){
		location.href = '${pageContext.request.contextPath}/myPage/review?mode=qna';
	});
});
</script>
