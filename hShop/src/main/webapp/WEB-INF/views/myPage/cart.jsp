<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style type="text/css">
.body-container {
	max-width: 1000px;
}

.left { text-align: left; padding-left: 7px; }
.right { text-align: right; padding-right: 7px; }

.product-title{ font-weight: 600; }
.product-options { color: #777; font-size: 12px; }

.cart-delete, .cart-deleteCheck { cursor: pointer; }
.cart-delete:hover, .cart-deleteCheck:hover { color: #1712AB; }

.select-count-label { color: #777; font-size: 12px; }
.cart-list > thead tr:first-child { border-top: 2px solid #212529; }
.cart-list td { padding: 3px; }
</style>

<script type="text/javascript">
$(function(){
	let cartSize = "${list.size()}";
	if(cartSize!=="" && cartSize!=="0") {
		$(".cart-chkAll").prop("checked", true);
		$("form input[name=nums]").prop("checked", true);
	}
	
    $(".cart-chkAll").click(function() {
    	$("form input[name=nums]").prop("checked", $(this).is(":checked"));
    });
});

function sendOk() {
	// 구매하기
	const f = document.cartForm;
	
	let cnt = $("form input[name=nums]:checked").length;
    if (cnt === 0) {
		alert("구매할 상품을 먼저 선택 하세요 !!!");
		return;
    }
    
    let b = true;
    $("form input[name=nums]").each(function(index, item){
		if($(this).is(":checked")) {
			let totalStock = Number($(this).attr("data-totalStock"));
			let $tr = $(this).closest("tr");
			let qty = Number($tr.find("input[name=buyQtys]").val()) || 1;
			if(qty > totalStock) {
				b = false;
				return false;
			}
		}
	});
    
    if( ! b) {
    	alert('상품 재고가 부족합니다.')
    	return;
    }
    
    $("form input[name=nums]").each(function(index, item){
		if(! $(this).is(":checked")) {
			$(this).closest("tr").remove();
		}
	});
    
	f.action = "${pageContext.request.contextPath}/order/payment";
	f.submit();
}

function deleteCartAll() {
	// 장바구니 비우기
	if(! confirm('장바구니를 비우시겠습니까 ? ')) {
		return;
	}

	location.href = '${pageContext.request.contextPath}/myPage/deleteCartAll';	
}

function deleteCartSelect() {
	// 선택된 항목 삭제
	let cnt = $("form input[name=nums]:checked").length;
    if (cnt === 0) {
		alert("삭제할 상품을 먼저 선택 하세요 !!!");
		return;
    }
    
	if(! confirm('선택한 상품을 장바구니에서 비우시겠습니까 ? ')) {
		return;
	}
	
	const f = document.cartForm;
	f.action = "${pageContext.request.contextPath}/myPage/deleteListCart";
	f.submit();
}

function deleteCartItem(stockNum) {
	// 하나의 항목 삭제
	if(! confirm('선택한 상품을 장바구니에서 비우시겠습니까 ? ')) {
		return;
	}

	location.href = '${pageContext.request.contextPath}/myPage/deleteCart?stockNum=' + stockNum;	
}

$(function(){
	$(".btnMinus").click(function(){
		const $tr = $(this).closest("tr");
		let qty = Number($tr.find("input[name=buyQtys]").val()) || 1;
		let price = Number($tr.find("input[name=prices]").val()) || 0;
		let salePrice = Number($tr.find("input[name=salePrices]").val()) || 0;
		
		if(qty <= 1) {
			return false;
		}
		
		qty--;
		$tr.find("input[name=buyQtys]").val(qty);
		let total = salePrice * qty;
		
		$tr.find(".productMoneys").text(total.toLocaleString());
		$tr.find("input[name=productMoneys]").val(total);
	});

	$(".btnPlus").click(function(){
		const $tr = $(this).closest("tr");
		let totalStock = Number($tr.find("input[name=nums]").attr("data-totalStock"));
		
		let qty = Number($tr.find("input[name=buyQtys]").val()) || 1;
		let price = Number($tr.find("input[name=prices]").val()) || 0;
		let salePrice = Number($tr.find("input[name=salePrices]").val()) || 0;
		
		if(totalStock <= qty) {
			alert("상품 재고가 부족 합니다.");
			return false;
		}
		
		if(qty >= 99) {
			return false;
		}
		
		qty++;
		$tr.find("input[name=buyQtys]").val(qty);
		let total = salePrice * qty;
		
		$tr.find(".productMoneys").text(total.toLocaleString());
		$tr.find("input[name=productMoneys]").val(total);
	});
});
</script>

<div class="container">
	<div class="body-container">	
		<div class="body-title">
			<h3><i class="bi bi-cart"></i> 장바구니 </h3>
		</div>
		
		<div class="body-main pt-3">
			
			<form name="cartForm" method="post">
				<div style="padding: 15px 0 5px;">
					<button type="button" class="btn cart-deleteCheck" onclick="deleteCartSelect()();">선택삭제</button>
				</div>
				<table class="table cart-list">
					<thead>
						<tr class="bg-light text-center">
							<th width="35">
								<input type="checkbox" class="form-check-input cart-chkAll" name="chkAll">
							</th>
							<th colspan="2">
								상품명
							</th>
							<th width="140">수량</th>
							<th width="110">상품가격</th>
							<th width="100">할인금액</th>
							<th width="120">합계</th>
							<th width="80">배송비</th>
							<th width="55">삭제</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="dto" items="${list}">
							<tr class="text-center" valign="middle">
								<td>
									<input type="checkbox" class="form-check-input" name="nums" value="${dto.stockNum}" 
											data-totalStock="${dto.totalStock}" ${dto.totalStock == 0 ? "disabled":""}>
								</td>
								<td width="55">
									<img class="border rounded" width="50" height="50" src="${pageContext.request.contextPath}/uploads/product/${dto.thumbnail}">
								</td>
								<td>
									<p class="product-title p-1 mb-0 left">${dto.productName}</p>
									<p class="product-options p-1 mb-0 left">
										<c:if test="${dto.optionCount == 1}">
											선택사항 : ${dto.optionValue}
										</c:if>
										<c:if test="${dto.optionCount == 2}">
											선택사항 : ${dto.optionValue}, ${dto.optionValue2}
										</c:if>
										<c:if test="${dto.totalStock <= 5}">
											&nbsp;&nbsp;&nbsp;재고 : ${dto.totalStock}
										</c:if>
									</p>
									<input type="hidden" name="productNums" value="${dto.productNum}">
									<input type="hidden" name="stockNums" value="${dto.stockNum}">
								</td>
								<td>
									<div class="input-group">
										<button type="button" class="btn border btnMinus"><i class="bi bi-dash"></i></button>
										<input type="text" name="buyQtys" value="${dto.qty}" readonly class="form-control" style="width: 40px; text-align: center;">
										<button type="button" class="btn border btnPlus"><i class="bi bi-plus"></i></button>
									</div>
								</td>
								<td>
									<label><fmt:formatNumber value="${dto.price}"/></label><label>원</label>
									<input type="hidden" name="prices" value="${dto.price}">
								</td>
								<td>
									<label><fmt:formatNumber value="${dto.salePrice}"/></label><label>원</label>
									<input type="hidden" name="salePrices" value="${dto.salePrice}">
								</td>
								<td>
									<label class="productMoneys"><fmt:formatNumber value="${dto.productMoney}"/></label><label>원</label>
									<input type="hidden" name="productMoneys" value="${dto.productMoney}">
								</td>
								<td>
									<label><fmt:formatNumber value="${dto.delivery}"/></label><label>원</label>
								</td>
								<td>
									<button type="button" class="btn cart-delete" onclick="deleteCartItem('${dto.stockNum}')"><i class="bi bi-x"></i></button>
								</td>
							</tr>
						
						</c:forEach>
					</tbody>
				</table>
				
				<c:choose>
					<c:when test="${list.size() == 0}">
						<div class="mt-3 p-3 text-center">
							등록된 상품이 없습니다.
						</div>
					</c:when>
					<c:otherwise>
						<div class="mt-3 p-3 text-end">
							<input type="hidden" name="mode" value="cart">
							<button type="button" class="btn border btn-primary" style="width: 200px;" onclick="sendOk();"> 선택상품 구매하기 </button>
							<button type="button" class="btn border btn-light" onclick="deleteCartAll();"> 장바구니 모두 비우기 </button>
						</div>
					</c:otherwise>
				</c:choose>
			</form>
			
		</div>
	</div>
</div>
