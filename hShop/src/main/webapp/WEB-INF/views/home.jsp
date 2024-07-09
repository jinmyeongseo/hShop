<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style type="text/css">
.jumbo-img {
	vertical-align: top;
	max-height: 450px;
	width: 100%;
}

.product-img {
	vertical-align: top;
	height: 210px;
	width: 100%;
}

.product-item {
	cursor: pointer;
	overflow: hidden;
}

.page-move {
	width: 45px; height: 45px; line-height: 45px;
	z-index: 1000;
	border-radius: 45px;
	text-align: center;
	background: white;
	/* opacity:0.8; */
	font-weight: bold;
}
.page-move:hover {
	cursor: pointer;
	color: red;
}
</style>

<script type="text/javascript">
$(function(){
	$(".product-item").click(function(){
		let productNum = $(this).attr("data-productNum");
		let url = "${pageContext.request.contextPath}/product/"+productNum;
		location.href = url;
	});
	
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
	$(".product-container").each(function(){
		if($(this).find(".product-inner").length < 1) {
			$(this).hide();
		} else if($(this).find(".product-inner").length === 1) {
			$(this).find(".page-move-right").hide();
		}
	});
	
	$(".product-container .product-inner").hide();
	$(".product-container").find(".product-inner:first").show();
	$(".page-move-left").hide();
	
	$(".page-move-left").click(function(){
		let $ps = $(this).closest(".product-container");
		
		let $show = null;
		$ps.find(".product-inner").each(function(){
			if($(this).is(':visible')) {
				$show = $(this);
				return false;
			}
		});
		
		if($show && $ps.find(".product-inner:first").index() !== $show.index()) {
			$show.hide('slide');
			$show.prev().show('slide');
			$ps.find(".page-move-right").show();
			if($ps.find(".product-inner:first").index() === $show.prev().index()) {
				$ps.find(".page-move-left").hide();
			}
		}
	});
	
	$(".page-move-right").click(function(){
		let $ps = $(this).closest(".product-container");
		
		let $show = null;
		$ps.find(".product-inner").each(function(){
			if($(this).is(':visible')) {
				$show = $(this);
				return false;
			}
		});

		if($show && $ps.find(".product-inner:last").index() !== $show.index()) {
			$show.hide('slide');
			$show.next().show('slide');
			$ps.find(".page-move-left").show();
			if($ps.find(".product-inner:last").index() === $show.next().index()) {
				$ps.find(".page-move-right").hide();
			}
		}
	});
});

$(function(){
	$(".product-container").each(function(){
		if($(this).find(".product-inner").length < 1) {
			$(this).closest(".product-container").parent().hide();
			$(this).parent().next(".see-more").hide();
		}
	});
});
</script>

<div class="container">
	<!-- 점보 시작 -->
	<div class="container-fluid mt-2">
		<div id="carouselJumbo" class="carousel slide" data-bs-ride="carousel">
			<div class="carousel-indicators">
				<button type="button" data-bs-target="#carouselJumbo" data-bs-slide-to="0" class="active" aria-current="true" aria-label="내셔널지오그래픽"></button>
				<button type="button" data-bs-target="#carouselJumbo" data-bs-slide-to="1" class="" aria-current="true" aria-label="디스커버리 "></button>
				<button type="button" data-bs-target="#carouselJumbo" data-bs-slide-to="2" class="" aria-current="true" aria-label="아디다스"></button>
				<button type="button" data-bs-target="#carouselJumbo" data-bs-slide-to="3" class="" aria-current="true" aria-label="나이키"></button>
			</div>
			
			<div class="carousel-inner">
				<div class="carousel-item active">
					<a href="#">
						<img src="${pageContext.request.contextPath}/uploads/jumbo/ad01.png"
							 class="d-block jumbo-img">
					</a>
					<div class="carousel-caption d-none d-md-block">
						<h5>내셔널지오그래픽</h5>
					</div>
				</div>
			
				<div class="carousel-item">
					<a href="#">
						<img src="${pageContext.request.contextPath}/uploads/jumbo/ad02.png"
							 class="d-block jumbo-img">
					</a>
					<div class="carousel-caption d-none d-md-block">
						<h5>디스커버리</h5>
					</div>
				</div>
			
				<div class="carousel-item">
					<a href="#">
						<img src="${pageContext.request.contextPath}/uploads/jumbo/ad03.png"
							 class="d-block jumbo-img">
					</a>
					<div class="carousel-caption d-none d-md-block">
						<h5>아디다스</h5>
					</div>
				</div>

				<div class="carousel-item">
					<a href="#">
						<img src="${pageContext.request.contextPath}/uploads/jumbo/ad04.png"
							 class="d-block jumbo-img">
					</a>
					<div class="carousel-caption d-none d-md-block">
						<h5>나이키</h5>
					</div>
				</div>
			</div>
			
			<button class="carousel-control-prev" type="button" data-bs-target="#carouselJumbo" data-bs-slide="prev">
				<span class="carousel-control-prev-icon" aria-hidden="true"></span>
				<span class="visually-hidden">Previous</span>
			</button>
			<button class="carousel-control-next" type="button" data-bs-target="#carouselJumbo" data-bs-slide="next">
				<span class="carousel-control-next-icon" aria-hidden="true"></span>
				<span class="visually-hidden">Next</span>
			</button>					
		</div>
	</div>
	
	<!-- 오늘의 특가 -->
	<div class="container-fluid">
		<div class="mt-3 py-3">
			<h3 class="fw-semibold">오늘의 특가</h3>
			
			<div class="position-relative product-container mt-3">
				<div class="border position-absolute top-50 start-0 page-move page-move-left">
					<i class="bi bi-chevron-left"></i>
				</div>
				
				<c:forEach var="dto" items="${todayList}" varStatus="status">
					<c:if test="${status.count % 4 == 1}">
						${not status.first ? '</div>' : ''}
						<c:out value="<div class='row px-4 product-inner'>" escapeXml="false"/>					
					</c:if>
						<div class="col-md-3">
							<div class="img-thumbnail product-item" data-productNum="${dto.productNum}">
								<img class="product-img rounded" src="${pageContext.request.contextPath}/uploads/product/${dto.thumbnail}">
								<div class="p-2">
									<div class="text-truncate fw-semibold pt-2 pb-1">${dto.productName}</div>
									<div class="pb-1">
										<label class="fs-5 pe-2 text-danger">${dto.discountRate}%</label>
										<label class="fs-5 pe-2 fw-semibold"><fmt:formatNumber value="${dto.salePrice}"/>원</label>
										<label class="fs-6 fw-light text-decoration-line-through"><fmt:formatNumber value="${dto.price}"/>원</label>
									</div>
									<div class="row pb-1">
										<div class="col">
											${dto.delivery==0 ? "무료 배송" : "&nbsp;"}
										</div>
										<div class="col text-end">${dto.saleCount}개 구매</div>
									</div>
								</div>
							</div>
						</div>
						
					<c:if test="${status.last}">
						<c:out value="</div>" escapeXml="false"/>					
					</c:if>
				</c:forEach>
				
				<div class="border position-absolute top-50 end-0 page-move page-move-right">
					<i class="bi bi-chevron-right"></i>
				</div>
				
			</div>
		</div>
		
		<div class="pt-2 text-end see-more">
			<a class="text-reset" href="#">자세히 보기 <i class="bi bi-arrow-right-circle"></i></a>
		</div>
	</div>
	
	<!-- 기획전 -->
	<div class="container-fluid mt-3">
		<div class="mt-3 py-3">
			<h3 class="fw-semibold">기획전</h3>
			
			<div class="position-relative product-container mt-3">
				<div class="border position-absolute top-50 start-0 page-move page-move-left">
					<i class="bi bi-chevron-left"></i>
				</div>
				
				<c:forEach var="dto" items="${planList}" varStatus="status">
					<c:if test="${status.count % 4 == 1}">
						${not status.first ? '</div>' : ''}
						<c:out value="<div class='row px-4 product-inner'>" escapeXml="false"/>					
					</c:if>
						<div class="col-md-3">
							<div class="img-thumbnail product-item" data-productNum="${dto.productNum}">
								<img class="product-img rounded" src="${pageContext.request.contextPath}/uploads/product/${dto.thumbnail}">
								<div class="p-2">
									<div class="text-truncate fw-semibold pt-2 pb-1">${dto.productName}</div>
									<div class="pb-1">
										<label class="fs-5 pe-2 text-danger">${dto.discountRate}%</label>
										<label class="fs-5 pe-2 fw-semibold"><fmt:formatNumber value="${dto.salePrice}"/>원</label>
										<label class="fs-6 fw-light text-decoration-line-through"><fmt:formatNumber value="${dto.price}"/>원</label>
									</div>
									<div class="row pb-1">
										<div class="col">
											${dto.delivery==0 ? "무료 배송" : "&nbsp;"}
										</div>
										<div class="col text-end">${dto.saleCount}개 구매</div>
									</div>
								</div>
							</div>
						</div>
						
					<c:if test="${status.last}">
						<c:out value="</div>" escapeXml="false"/>					
					</c:if>
				</c:forEach>
				
				<div class="border position-absolute top-50 end-0 page-move page-move-right">
					<i class="bi bi-chevron-right"></i>
				</div>
				
			</div>
		</div>
		
		<div class="pt-2 text-end see-more">
			<a class="text-reset" href="#">자세히 보기 <i class="bi bi-arrow-right-circle"></i></a>
		</div>
	</div>
	
</div>