<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="fs-6 py-1"><i class="bi bi-stop"></i> 구매 상품</div>
<table class="table table-bordered mb-1">
	<tr>
		<td class="table-light" width="110">상품명</td>
		<td colspan="5">
			${dto.productName}
		</td>
	</tr>
	
	<tr>
		<td class="table-light" width="110">주문상태</td>
		<td width="150">${dto.detailStateInfo}</td>
		<td class="table-light" width="110">옵션</td>
		<td width="150">
			<c:choose>
				<c:when test="${dto.optionCount==0}">옵션 없음</c:when>
				<c:when test="${dto.optionCount==1}">${dto.optionValue}</c:when>
				<c:when test="${dto.optionCount==2}">${dto.optionValue} / ${dto.optionValue2}</c:when>
			</c:choose>
		</td>
		<td class="table-light" width="110">금액</td>
		<td><fmt:formatNumber value="${dto.salePrice}"/></td>
	</tr>
	
	<tr>
		<td class="table-light">주문수량</td>
		<td>${dto.qty}</td>
		<td class="table-light">구매총금액</td>
		<td><fmt:formatNumber value="${dto.productMoney}"/></td>
		<td class="table-light">적립금</td>
		<td><fmt:formatNumber value="${dto.savedMoney}"/></td>
	</tr>
</table>

<c:if test="${listBuy.size() > 1}">
	<div class="fs-6 pt-3 pb-1"><i class="bi bi-stop"></i> 함께 구매한 상품</div>
	<table class="table table-bordered mb-1">
	<c:forEach var="vo" items="${listBuy}">
		<c:if test="${dto.orderDetailNum != vo.orderDetailNum}">
			<tr>
				<td>
					${vo.productName}
					<c:choose>
						<c:when test="${vo.optionCount==1}">(${vo.optionValue})</c:when>
						<c:when test="${vo.optionCount==2}">(${vo.optionValue} / ${vo.optionValue2})</c:when>
					</c:choose>

					&nbsp;수량 : ${vo.qty}
					&nbsp;금액 : <fmt:formatNumber value="${vo.productMoney}"/>
				</td>
			</tr>
		</c:if>
	</c:forEach>
	</table>
</c:if>

<div class="fs-6 pt-3 pb-1"><i class="bi bi-stop"></i> 결제 정보</div>
<table class="table table-bordered mb-1">
	<tr>
		<td class="table-light" width="110">결제카드</td>
		<td width="150">${dto.cardName}</td>
		<td class="table-light" width="110">승인일자</td>
		<td colspan="3">${dto.authDate}</td>
	</tr>
	<tr>
		<td class="table-light" width="110">총금액</td>
		<td width="150"><fmt:formatNumber value="${dto.totalMoney + dto.deliveryCharge}"/></td>
		<td class="table-light" width="110">포인트사용액</td>
		<td width="150">${dto.usedSaved}</td>
		<td class="table-light" width="110">결제금액</td>
		<td><fmt:formatNumber value="${dto.payment}"/></td>
	</tr>
</table>

<div class="fs-6 py-1 mt-2"><i class="bi bi-stop"></i> 배송 정보</div>
<table class="table table-bordered mb-1">
	<tr>
		<td class="table-light" width="110">받는사람</td>
		<td width="150">${orderDelivery.recipientName}</td>
		<td class="table-light" width="110">전화번호</td>
		<td width="150">${orderDelivery.tel}</td>
		<td class="table-light" width="110">배송비</td>
		<td>${dto.deliveryCharge}</td>
	</tr>
	<tr>
		<td class="table-light" width="110">주소</td>
		<td colspan="5">${orderDelivery.addr1} ${orderDelivery.addr2}</td>
	</tr>
	<tr>
		<td class="table-light" width="110">배송 메모</td>
		<td colspan="5">${orderDelivery.destMemo}</td>
	</tr>
</table>
