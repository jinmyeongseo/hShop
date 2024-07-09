<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

	<script type="text/javascript">
		$(function(){
			$("ul.condition>li>a").click(function(){
				$("ul.condition>li>a").removeClass("text-danger");
				$(this).addClass("text-danger");
				
				$(this).closest("form").find("input[name=searchType]").val($(this).attr("data-condition"));
				$(this).closest("div").find("button").text($(this).text());
			});
		});
	</script>
	
	<div class="container-fluid header-top">
		<div class="container">
			<div class="row align-items-center p-2">
				<div class="col">
					<i class="bi bi-telephone-inbound-fill"></i> +82-1234-1234
				</div>
				
				<form class="col-6">
					<div class="input-group input-group-sm p-2">
						<button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">통합검색</button>
						<ul class="dropdown-menu condition">
							<li><a class="dropdown-item text-danger" href="#" data-condition="all">통합검색</a></li>
							<li><a class="dropdown-item" href="#" data-condition="best">베스트</a></li>
							<li><a class="dropdown-item" href="#" data-condition="project">기획전</a></li>
						</ul>
  
						<input type="text" name="searchWord" class="form-control" placeholder="검색어를 입력하세요" aria-describedby="basic-addon1">
						<span class="input-group-text" id="basic-addon1"><i class="bi bi-search"></i></span>
						<input type="hidden" name="searchType" value="all">
					</div>
				</form>				
				
				<div class="col">
					<div class="d-flex justify-content-end">
						<div class="p-2">
							<a href="javascript:recentProductView();" title="최근 본 상품"><i class="bi bi-view-list"></i></a>
						</div>
						<div class="p-2">
							<a href="#" title="장바구니"><i class="bi bi-cart"></i></a>
						</div>
						<c:choose>
							<c:when test="${empty sessionScope.member}">
								<div class="p-2">
									<a href="javascript:dialogLogin();" title="로그인"><i class="bi bi-lock"></i></a>
								</div>
								<div class="p-2">
									<a href="${pageContext.request.contextPath}/" title="회원가입"><i class="bi bi-person-plus"></i></a>
								</div>	
							</c:when>
							<c:otherwise>
								<div class="p-2">
									<a href="${pageContext.request.contextPath}/member/logout" title="로그아웃"><i class="bi bi-unlock"></i></a>
								</div>					
								<div class="p-2">
									<a href="#" title="알림"><i class="bi bi-bell"></i></a>
								</div>
								<c:if test="${sessionScope.member.membership>50}">
									<div class="p-2">
										<a href="${pageContext.request.contextPath}/admin" title="관리자"><i class="bi bi-gear"></i></a>
									</div>					
								</c:if>
							</c:otherwise>
						</c:choose>
					</div>
					
				</div>
			</div>
		</div>
	</div>
	
	<nav class="navbar navbar-expand-lg navbar-light">
		<div class="container">
			<a class="navbar-brand" href="${pageContext.request.contextPath}/"><i class="bi bi-app-indicator"></i></a>
			<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
				
			<div class="collapse navbar-collapse" id="navbarSupportedContent">
				<ul class="navbar-nav mx-auto flex-nowrap">
					<li class="nav-item">
						<a class="nav-link" aria-current="page" href="${pageContext.request.contextPath}/">홈</a>
					</li>
					
					<li class="nav-item">
						<a class="nav-link" href="#">베스트</a>
					</li>

					<li class="nav-item">
						<a class="nav-link" href="#">오늘의 특가</a>
					</li>

					<li class="nav-item">
						<a class="nav-link" href="#">기획전</a>
					</li>
	
					<li class="nav-item">
						<a class="nav-link" data-bs-toggle="offcanvas" href="#offcanvasCategory" aria-controls="offcanvasCategory">카테고리</a>
					</li>

					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
							혜택
						</a>
						<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
							<li><a class="dropdown-item" href="#">쿠폰</a></li>
							<li><a class="dropdown-item" href="#">이벤트</a></li>
							<li><hr class="dropdown-divider"></li>
							<li><a class="dropdown-item" href="#">당첨자발표</a></li>
						</ul>
					</li>
						
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
							고객센터
						</a>
						<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
							<li><a class="dropdown-item" href="#">자주하는질문</a></li>
							<li><a class="dropdown-item" href="#">공지사항</a></li>
							<li><hr class="dropdown-divider"></li>
							<li><a class="dropdown-item" href="#">1:1문의</a></li>
							<li><a class="dropdown-item" href="#">고객의 소리</a></li>
						</ul>
					</li>
					
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
							마이페이지
						</a>
						<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
							<li><a class="dropdown-item" href="${pageContext.request.contextPath}/myPage/paymentList">결제내역/주문/배송</a></li>
							<li><a class="dropdown-item" href="#">포인트/쿠폰</a></li>
							<li><a class="dropdown-item" href="#">찜</a></li>
							<li><a class="dropdown-item" href="${pageContext.request.contextPath}/myPage/review">리뷰/Q&amp;A</a></li>
							<li><a class="dropdown-item" href="#">정보수정</a></li>
						</ul>
					</li>
					
				</ul>
			</div>
			
		</div>
	</nav>

	<!-- 좌측 카테고리 오프캔버스 -->
	<div class="offcanvas offcanvas-start" tabindex="-1" id="offcanvasCategory" aria-labelledby="offcanvasCategoryLabel">
		<div class="offcanvas-header">
			<h5 class="offcanvas-title" id="offcanvasCategoryLabel"><i class="bi bi-layout-text-sidebar-reverse"></i> 상품 카테고리</h5>
			<button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
		</div>
		<div class="offcanvas-body">
			<div class="d-flex flex-column bd-highlight mt-3 px-2">
				<div class="list-group list-category">
				</div>
			</div>
		</div>
	</div>
	
	<script type="text/javascript">
	$(function(){
		const myOffcanvas = document.getElementById('offcanvasCategory');
		myOffcanvas.addEventListener('shown.bs.offcanvas', function () {
			let url = "${pageContext.request.contextPath}/product/listCategory";

			$.get(url, null, function(data){
				let out = "";
				let listUrl = "${pageContext.request.contextPath}/product/main?categoryNum=";
				// console.log(data);
				$(data).each(function(index, item){
					let categoryNum = item.categoryNum;
					let categoryName = item.categoryName;
					
					out += "<a href='"+listUrl+categoryNum+"' class='list-group-item list-group-item-action'>"+categoryName+"<a>";
				});
				$(".list-category").html(out);
				
			}, "json");
		});	
	});
	</script>
	
	<!-- 최근본 상품 목록 -->
	<div class="modal fade" id="productViewModal" tabindex="-1" aria-labelledby="productViewModalLabel" aria-hidden="true">
	  <div class="modal-dialog modal-dialog-centered">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h1 class="modal-title fs-5" id="productViewModalLabel">최근본상품목록</h1>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body modal-recentProductView">
	      	최근에 본 상품 목록이 없습니다.
	      </div>
	    </div>
	  </div>
	</div>
	
	<style>
		.product-img { height: 150px; width: 150px; cursor: pointer; }
	</style>
	
	<script type="text/javascript">
		function recentProductView() {
			$(".modal-recentProductView").empty();
			
			let product = JSON.parse(localStorage.getItem("product")) || [];
			let out = "";
			
			out += "<div class='row row-cols-3 g-3'>";
			for(let item of product) {
				let productNum = item.pnum;
				let productName = item.pname;
				let img = item.pimg;
				
				out += "<div class='col p-1' style='width=750px;'>";
				out += "  <div class='border rounded'>";
				out += "    <a href='${pageContext.request.contextPath}/product/"+productNum+"'>";
				out += "      <img class='product-img' src='${pageContext.request.contextPath}/uploads/product/"+img+"'>";
				out += "    </a>";
				out += "    <div class='text-truncate p-2 mt-1'>" + productName + "</div>";
				out += "  </div>";
				out += "</div>";
			}
			out += "</div>";
			
			$(".modal-recentProductView").html(out);
			
			$("#productViewModal").modal("show");
		}
	</script>	
