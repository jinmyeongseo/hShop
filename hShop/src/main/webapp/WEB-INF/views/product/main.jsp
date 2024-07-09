<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
.product-item {
	cursor: pointer;
	overflow: hidden;
}
.thumbnail-img {
	width: 100%;
	min-height: 210px;
	max-height: 210px;
	vertical-align: top;
	object-fit: cover;
}
</style>

<script type="text/javascript">
$(function(){
	$(".product-item").mouseenter(function(e){
		$(this).find("img").css("transform", "scale(1.05)");
		$(this).find("img").css("overflow", "hidden");
		$(this).find("img").css("transition", "all 0.5s");
	});
	
	$(".product-item").mouseleave(function(e){
		$(this).find("img").css("transform", "scale(1)");
		$(this).find("img").css("transition", "all 0.5s");
	});
});

$(function(){
	$(".product-item").click(function(){
		let productNum = $(this).attr("data-productNum");
		let url = "${pageContext.request.contextPath}/product/"+productNum;
		location.href = url;
	});
});

</script>

<div class="container body-container">
    <div class="inner-page">
		
		<div class="row mt-1">
			<c:forEach var="dto" items="${list}" varStatus="status">
				<div class="col-md-4 col-lg-3 mt-4">
					<div class="border rounded product-item" data-productNum="${dto.productNum}">
						<img class="thumbnail-img" src="${pageContext.request.contextPath}/uploads/product/${dto.thumbnail}">
						<div class="p-2">
							<div class="text-truncate fw-semibold pb-1">
								${dto.productName}
							</div>
							<div class="pb-1">
								<c:if test="${dto.discountRate != 0}">
							  		<label class="fs-5 pe-2 text-danger">${dto.discountRate}%</label>
								</c:if>
							  	<label class="fs-5 pe-2 fw-semibold"><fmt:formatNumber value="${dto.salePrice}"/>원</label>
								<c:if test="${dto.discountRate != 0}">
							  		<label class="fs-6 fw-light text-decoration-line-through"><fmt:formatNumber value="${dto.price}"/>원</label>
								</c:if>
							</div>
						</div>
					</div>
				</div>
			</c:forEach>
		</div>
		
		<div class="page-navigation mt-5">
			${dataCount == 0 ? "등록된 상품이 없습니다." : paging}
		</div>
		
    </div>
</div>