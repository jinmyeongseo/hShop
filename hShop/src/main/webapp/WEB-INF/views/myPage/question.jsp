<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style type="text/css">
.body-container {
	max-width: 1000px;
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

.md-img img { width: 150px; height: 150px; cursor: pointer; object-fit: cover; }
.deleteQuestion { cursor: pointer; padding-left: 5px; }
.deleteQuestion:hover { font-weight: 500; color: #2478FF; }
</style>

<script type="text/javascript">
$(function(){
	$("button[role='tab']").on('click', function(){
		const tab = $(this).attr("aria-controls");
		
		if(tab === "1") { // review
			location.href = "${pageContext.request.contextPath}/myPage/review";
		}
	});
});

$(function(){
	$(".deleteQuestion").click(function(){
		let num = $(this).attr("data-num");
		alert(num);
	});
});
</script>

<div class="container">
	<div class="body-container">	
		<div class="body-main">

			<ul class="nav nav-tabs mt-5" id="myTab" role="tablist">
				<li class="nav-item" role="presentation">
					<button class="nav-link" id="tab-1" data-bs-toggle="tab" data-bs-target="#tab-pane-1" type="button" role="tab" aria-controls="1" aria-selected="false"> 리뷰 </button>
				</li>
				<li class="nav-item" role="presentation">
					<button class="nav-link active" id="tab-2" data-bs-toggle="tab" data-bs-target="#tab-pane-2" type="button" role="tab" aria-controls="2" aria-selected="false"> 상품문의 </button>
				</li>
			</ul>
			
			<div class="tab-content pt-2" id="myTabContent">
				<div class="tab-pane fade" id="tab-pane-1" role="tabpanel" aria-labelledby="tab-1" tabindex="0">
					<div class="mt-3 pt-3 border-bottom">
						<p class="fs-4 fw-semibold">상품 리뷰</p> 
					</div>
					
					<div id="listReview" class="mt-2"></div>
				</div>
				
				<div class="tab-pane fade show active" id="tab-pane-2" role="tabpanel" aria-labelledby="tab-2" tabindex="0">
					<div class="mt-3 pt-3 border-bottom">
						<p class="fs-4 fw-semibold">상품 문의 사항</p> 
					</div>
			
					<div class="mt-1 p-2 list-question">
						<c:forEach var="dto" items="${list}">
							<div class="mt-1 border-bottom">
								<div class="row p-2">
									<div class="col-auto fw-semibold">
										${dto.productName}
									</div>
									<div class="col text-end">
										${not empty dto.answer ? '<span class="text-primary">답변완료</span>' : '<span class="text-secondary">답변대기</span>'}
										| ${dto.question_date}
										|<span class="deleteQuestion" data-num="${dto.num}">삭제</span>
									</div>
								</div>
								<div class="p-2">
									${dto.question}
								</div>
								<c:if test="${not empty dto.listFilename}">
									<div class="row gx-1 mt-2 mb-1 p-1">
										<c:forEach var="filename" items="${dto.listFilename}">
											<div class="col-md-auto md-img">
												<img class="border rounded" src="${pageContext.request.contextPath}/uploads/qna/${filename}">
											</div>
										</c:forEach>
									</div>
								</c:if>
								<c:if test="${not empty dto.answer}">
									<div class="p-3 pt-0">
										<div class="bg-light">
											<div class="p-3 pb-0">
												<label class="text-bg-primary px-2"> 관리자 </label> <label>${dto.answer_date}</label>
											</div>
											<div class="p-3 pt-1">${dto.answer}</div>
										</div>
									</div>						
								</c:if>						
							</div>
						</c:forEach>
					</div>
					<div class="page-navigation">${paging}</div>
				</div>
			</div>

		</div>
	</div>
</div>

