<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
	
	<nav class="navbar navbar-expand-lg bg-light">
		<div class="container">
			<a class="navbar-brand" href="${pageContext.request.contextPath}/"><i class="bi bi-app-indicator"></i></a>
			<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
				
			<div class="collapse navbar-collapse" id="navbarSupportedContent">
				<ul class="navbar-nav mx-auto flex-nowrap">
					<li class="nav-item">
						<a class="nav-link" aria-current="page" href="${pageContext.request.contextPath}/admin">홈</a>
					</li>
					
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
							주문관리
						</a>
						<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
							<li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/order/status">주문현황</a></li>
							<li><hr class="dropdown-divider"></li>
							<li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin">교환관리</a></li>
							<li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin">반품및주문취소</a></li>
						</ul>
					</li>

					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
							상품및재고관리
						</a>
						<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
							<li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/product/main">상품관리</a></li>
							<li><hr class="dropdown-divider"></li>
							<li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/specials/200/main">오늘의특가</a></li>
							<li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/specials/300/main">기획전</a></li>
						</ul>
					</li>
	
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
							리뷰 및 문의
						</a>
						<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
							<li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/customer/review">상품리뷰</a></li>
							<li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/customer/question">상품질문과답변</a></li>
							<li><hr class="dropdown-divider"></li>
							<li><a class="dropdown-item" href="#">쪽지</a></li>
						</ul>
					</li>

					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
							고객센터관리
						</a>
						<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
							<li><a class="dropdown-item" href="#">자주하는 질문</a></li>
							<li><a class="dropdown-item" href="#">공지사항</a></li>
							<li><a class="dropdown-item" href="#">1:1 문의</a></li>
							<li><a class="dropdown-item" href="#">신고</a></li>
							<li><hr class="dropdown-divider"></li>
							<li><a class="dropdown-item" href="#">실시간 채팅 문의</a></li>
						</ul>
					</li>

					<li class="nav-item">
						<a class="nav-link" href="#">매출현황</a>
					</li>

					<li class="nav-item">
						<a class="nav-link" href="#">환경설정</a>
					</li>
				</ul>
			</div>
			
		</div>
	</nav>
