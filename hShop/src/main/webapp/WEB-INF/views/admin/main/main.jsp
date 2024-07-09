<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/echarts/5.5.0/echarts.min.js"></script>

<script type="text/javascript">

</script>

<div class="container body-container">
    <div class="inner-page">
    
    	<div class="row g-1 mt-4 p-1">
			<div class="col p-2">
				<div class="fs-6 fw-semibold mb-2"><i class="bi bi-chevron-right"></i> 오늘 판매 현황</div>
				<div class="border rounded p-5 text-center">
					<div class="fs-5 mb-2">총 판매 건수 : 
						<span class="product-totalAmount fw-semibold text-primary">${today.COUNT}</span>
					</div>
					<div class="fs-5">총 판매 금액 : 
						<span class="product-totalAmount fw-semibold text-danger"><fmt:formatNumber value="${today.TOTAL}"/></span>원
					</div>
				</div>
			</div>
			
			<div class="col p-2">
				<div class="fs-6 fw-semibold mb-2"><i class="bi bi-chevron-right"></i> 이번달 판매 현황</div>
				<div class="border rounded p-5 text-center">
					<div class="fs-5 mb-2">총 판매 건수 : 
						<span class="product-totalAmount fw-semibold text-primary">${thisMonth.COUNT}</span>
					</div>
					<div class="fs-5">총 판매 금액 : 
						<span class="product-totalAmount fw-semibold text-danger"><fmt:formatNumber value="${thisMonth.TOTAL}"/></span>원
					</div>
				</div>
			</div>
    	
			<div class="col p-2">
				<div class="fs-6 fw-semibold mb-2"><i class="bi bi-chevron-right"></i> 전월 판매 현황</div>
				<div class="border rounded p-5 text-center">
					<div class="fs-5 mb-2">총 판매 건수 : 
						<span class="product-totalAmount fw-semibold text-primary">${previousMonth.COUNT}</span>
					</div>
					<div class="fs-5">총 판매 금액 : 
						<span class="product-totalAmount fw-semibold text-danger"><fmt:formatNumber value="${previousMonth.TOTAL}"/></span>원
					</div>
				</div>
			</div>
    	</div>
    
		<div class="row mt-4 p-1">
			<div class="col p-2">
				<div class="fs-6 fw-semibold mb-2"><i class="bi bi-chevron-right"></i> 최근 1주일 판매 현황</div>
				<div class="charts-day border rounded" style="height: 500px;"></div>
			</div>
			<div class="col p-2">
				<div class="fs-6 fw-semibold mb-2 "><i class="bi bi-chevron-right"></i> <label class="charts-dayOfWeek-title">전월 요일별 판매건수</label></div>
				<div class="charts-dayOfWeek border rounded" style="height: 500px;"></div>
			</div>
			<div class="col p-2">
				<div class="fs-6 fw-semibold mb-2"><i class="bi bi-chevron-right"></i> 최근 6개월 판매 현황</div>
				<div class="charts-month border rounded" style="height: 500px;"></div>
			</div>
		</div>		


    </div>
</div>