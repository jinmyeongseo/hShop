<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style type="text/css">
.body-container {
	max-width: 1000px;
}

.md-img {
	width: 80px; height: 80px;
}
</style>

<script type="text/javascript">
function sendOk() {
	const f = document.paymentForm;
	
	if(! f.recipientName.value) {
		alert("먼저 배송지를 등록하세요..");
		return;
	}
	
	if(! /^\d+$/.test(f.usedSaved.value)) {
		alert("숫자만 입력 가능합니다.");
		return;
	}

	let balance = Number($('.btn-usedSaved').attr('data-balance')) || 0;
	let usedSaved = Number(f.usedSaved.value);

	if(usedSaved > balance) {
		alert("사용 가능 포인터는 보유 포인터를 초과 할수 없습니다.");
		return;
	}
	
	// 결제 금액 = 총금액 - 포인트사용금액
	let p = Number(f.payment.value) - usedSaved;
	f.payment.value = p;
	
	// 결제 API에서 응답 받을 파라미터
	let payMethod = "카드결제"; // 결제유형
	let cardName = "BC 카드";  // 카드 이름
	let authNumber = "1234567890"; // 승인번호
	let authDate = ""; // 승인 날짜
	// toISOString() : "YYYY-MM-DDTHH:mm:ss.sssZ" 형식
	authDate = new Date().toISOString().replace('T', ' ').slice(0, -5); // YYYY-MM-DD HH:mm:ss

	// 결제 API에 요청할 파라미터
	let payment = f.payment.value; // 결제할 금액
	let merchant_uid = "${productOrderNumber}";  // 고유 주문번호
	let productName = "${productOrderName}";  // 주문상품명
	let buyer_email = "${orderUser.email}";  // 구매자 이메일
	let buyer_name = "${orderUser.userName}";  // 구매자 이름
	let buyer_tel = "${orderUser.tel}";   // 구매자 전화번호(필수)
	let buyer_addr = "${orderUser.addr1}" + " " + "${orderUser.addr2}";  // 구매자 주소
	buyer_addr = buyer_addr.trim();
	let buyer_postcode = "${orderUser.zip}"; // 구매자 우편번호
	
	// 결제 API로 결제 진행
	
	
	
	// 결제가 성공한 경우 ------------------------
	
	// 결제 방식, 카드번호, 승인번호, 결제 날짜
	f.payMethod.value = payMethod;
	f.cardName.value = cardName;
	f.authNumber.value = authNumber;
	f.authDate.value = authDate;
	
	f.action = "${pageContext.request.contextPath}/order/paymentOk"
	f.submit();
}
</script>

<div class="container">
	<div class="body-container">	
		<div class="body-title">
			<h3><i class="bi bi-credit-card"></i> 주문 / 결제 </h3>
		</div>
		
		<div class="body-main pt-3">
			<form name="paymentForm" method="post">
				<table class="table">
					<tr class="bg-light text-center">
						<th width="120">&nbsp;</th>
						<th>상품정보</th>
						<th width="80">구매적립</th>
						<th width="60">수량</th>
						<th width="120">할인금액</th>
						<th width="120">상품금액</th>
						<th width="120">총금액</th>
					</tr>
					
					<c:forEach var="dto" items="${listProduct}" varStatus="status">
						<tr class="text-center" valign="middle">
							<td>
								<img class="border rounded md-img" src="${pageContext.request.contextPath}/uploads/product/${dto.thumbnail}">
							</td>
							<td>
								<div class="fw-semibold">${dto.productName}</div>
								<div>
									<c:if test="${dto.optionCount==1}">
										${dto.optionName} : ${dto.optionValue}
									</c:if>
									<c:if test="${dto.optionCount==2}">
										${dto.optionName} : ${dto.optionValue} / 
										${dto.optionName2} : ${dto.optionValue2}
									</c:if>
								</div>
								
								<input type="hidden" name="productNums" value="${dto.productNum}">
								<input type="hidden" name="detailNums" value="${empty dto.detailNum ? 0 : dto.detailNum}">
								<input type="hidden" name="detailNums2" value="${empty dto.detailNum2 ? 0 : dto.detailNum2}">
								<input type="hidden" name="stockNums" value="${dto.stockNum}">
								<input type="hidden" name="buyQtys" value="${dto.qty}">
								<input type="hidden" name="productMoneys" value="${dto.productMoney}">
								<input type="hidden" name="prices" value="${dto.price}">
								<input type="hidden" name="salePrices" value="${dto.salePrice}">
								<input type="hidden" name="savedMoneys" value="${dto.savedMoney}">
							</td>
							<td>
								<fmt:formatNumber value="${dto.savedMoney}"/>
							</td>
							<td>
								${dto.qty}
							</td>
							<td>
								<fmt:formatNumber value="${dto.discountPrice}"/>원
							</td>
							<td >
								<div>
									<label class="fw-light text-decoration-line-through">
										<fmt:formatNumber value="${dto.price}"/>원
									</label>
								</div>
								<div>
									<label class="fw-semibold">
										<fmt:formatNumber value="${dto.salePrice}"/>원
									</label>								
								</div>
							</td>
							<td>
								<label class="fw-semibold">
									<fmt:formatNumber value="${dto.productMoney}"/>원
								</label>
							</td>
						</tr>
					</c:forEach>
				</table>
				
				<input type="hidden" name="orderNum" value="${productOrderNumber}">
				<input type="hidden" name="totalMoney" value="${totalMoney}">
				<input type="hidden" name="deliveryCharge" value="${deliveryCharge}">
				<input type="hidden" name="payment" value="${totalPayment}">

				<input type="hidden" name="mode" value="${mode}">

				<input type="hidden" name="payMethod" value="">
				<input type="hidden" name="cardName" value="">
				<input type="hidden" name="authNumber" value="">
				<input type="hidden" name="authDate" value="">

				<div class="p-3 border">
					<div class="fs-6 fw-semibold border-bottom pb-1">배송지 정보</div>
					<div class="row ps-2 pt-2">
						<div class="col-auto pe-2 mt-2">
							<label class="fw-semibold">김자바</label> <label class="text-primary">기본배송지</label>
						</div>
						<div class="col-auto">
							<button type="button" class="btn border"> 배송지변경 </button>
						</div>
					</div>
					<div class="ps-2 pt-2">
						<div class="pt-2">서울특별시 마포구 월드컵북로 21 풍성빌딩 2층</div>
						<div class="pt-2">010-1111-1111</div>
						<div class="pt-2 w-50">
							<input type="hidden" name="recipientName" value="김자바">
							<input type="hidden" name="tel" value="010-1111-2222">
							<input type="hidden" name="zip" value="111-111">
							<input type="hidden" name="addr1" value="서울특별시 마포구 월드컵북로">
							<input type="hidden" name="addr2" value="21 풍성빌딩 2층">
							<input type="text" name="destMeno" class="form-control" placeholder="요청사항을 입력합니다.">
						</div>
					</div>
				</div>
				
				<div class="p-3 border mt-3">
					<div class="fs-6 fw-semibold border-bottom pb-1">포인트</div>
					<div class="ps-2 pt-2">
						<div class="pt-2 fw-semibold">보유 <fmt:formatNumber value="${empty userPoint ? 0 : userPoint.balance}"/>원</div>
					</div>
					<div class="row ps-2 pt-2">
						<div class="col-6">
							<div class="input-group">
								<input type="number" class="form-control" name="usedSaved" value="0" min="0" max="${empty userPoint ? 0 : userPoint.balance}">
								<button type="button" class="input-group-text btn-usedSaved" data-balance="${empty userPoint ? 0 : userPoint.balance}">전액사용</button>
							</div>
						</div>
					</div>
				</div>				
				
				<div class="pt-3">
					<div class="text-end">
						<label class="fs-6 fw-semibold">총 결제금액 : </label>
						<label class="product-totalAmount fs-4 fw-bold text-primary">
							<fmt:formatNumber value="${totalPayment}"/>원
						</label>
					</div>
					<div class="ps-2 pt-2 text-end">
						<label>상품금액 : </label>
						<label>
							<fmt:formatNumber value="${totalMoney}"/>원
						</label>
					</div>
					<div class="ps-2 pt-1 text-end">
						<label>배송비 : </label>
						<label>
							<fmt:formatNumber value="${deliveryCharge}"/>원
						</label>
					</div>
					<div class="ps-2 pt-1 text-end">
						<label>포인트사용액 : </label>
						<label class="point-usedSaved">
							0원
						</label>
					</div>
				</div>
				
				<div class="pt-3">
					<div class="text-end">
						<label class="fs-6">포인트 적립 : </label>
						<label class="fs-5">
							<fmt:formatNumber value="${totalSavedMoney}"/>원
						</label>
					</div>
				</div>
				
				<div class="pt-3 pb-3 text-center">
					<button type="button" class="btn btn-primary btn-lg" style="width: 250px;" onclick="sendOk()">결제하기</button>
					<button type="button" class="btn btn-light btn-lg" style="width: 250px;" onclick="location.href='${pageContext.request.contextPath}/';">결제취소</button>
				</div>
			</form>
		</div>
	</div>
</div>

<script type="text/javascript">
$(function(){
	$('.btn-usedSaved').click(function(){
		const f = document.paymentForm;
		
		let balance = Number($(this).attr('data-balance')) || 0;
		f.usedSaved.value = balance;
		
		let payment = Number(f.payment.value) - balance;
		
		$('.product-totalAmount').text(payment.toLocaleString()+'원');
		$('.point-usedSaved').text(balance.toLocaleString()+'원');
	});
	
	$('form[name=paymentForm] input[name=usedSaved]').on('keyup mouseup', function() {                                                                                                                     
		const f = document.paymentForm;
		let balance = Number($('.btn-usedSaved').attr('data-balance')) || 0;
		let usedSaved = Number(f.usedSaved.value);
		
		if(usedSaved > balance) {
			usedSaved = balance;
			f.usedSaved.value = balance;
		}
		
		let payment = Number(f.payment.value) - usedSaved;
		
		$('.product-totalAmount').text(payment.toLocaleString()+'원');
		$('.point-usedSaved').text(usedSaved.toLocaleString()+'원');
	});
});
</script>
