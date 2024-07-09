<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style type="text/css">
.body-container {
	max-width: 850px;
}

.table .ellipsis {
	position: relative;
	min-width: 200px;
}
.table .ellipsis span {
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
	position: absolute;
	left: 9px;
	right: 9px;
	cursor: pointer;
}
.table .ellipsis:before {
	content: '';
	display: inline-block;
}

.score-star { font-size: 0; letter-spacing: -4px; }
.score-star .item {
	font-size: 22px; letter-spacing: 1px; display: inline-block;
	color: #ccc; text-decoration: none; vertical-align: middle;
}
.score-star .item:first-child{ margin-left: 0; }
.score-star .on { color: #95D9F1; }

.md-img img { width: 150px; height: 150px; cursor: pointer; object-fit: cover; }

.item-basic-content { cursor: pointer; }
.item-detail-content { display: none; }

.answer-form textarea { width: 100%; height: 75px; resize: none; }

.answerReview, .deleteReview { cursor: pointer; padding-left: 5px; }
.answerReview:hover, .deleteReview:hover { font-weight: 500; color: #2478FF; }
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/boot-board.css" type="text/css">

<script type="text/javascript">
$(function(){
	$('.item-basic-content').click(function(){
		const $basic = $(this);
		const $detail = $basic.next();
		if($detail.is(':visible')) {
			$detail.hide(100);
			$basic.addClass('border-bottom');
		} else {
			$detail.show(100);
			$basic.removeClass('border-bottom');
		}
	});
});

$(function(){
	$('.deleteReview').click(function(){
		let num = $(this).attr('data-num');
				
		if(confirm('게시글을 삭제 하시겠습니까 ? ')) {
			let query = 'page=${page}&mode=${mode}&num=' + num;
			location.href = '${pageContext.request.contextPath}/admin/customer/review/delete?' + query;
		}
	});
});

$(function(){
	$('.btnSearctList').click(function(){
		let mode = $(this).attr('data-mode');
		let url = '${pageContext.request.contextPath}/admin/customer/review';
		if(mode !== '1') {
			url += '?mode=' + mode;
		}
		location.href = url;
	});
});
</script>

<div class="container">
	<div class="body-container">	
		<div class="body-title">
			<h3><i class="bi bi-chat-right-text"></i> 상품 리뷰 </h3>
		</div>
		
		<div class="body-main">

	        <div class="row board-list-header">
	            <div class="col-auto me-auto ">
	            	<div class="btn-group" role="group">
	            		<button type="button" class="btn btnSearctList ${mode==1?'fw-semibold text-primary':'' }" data-mode="1"> 전체 </button>
	            		<button type="button" class="btn btnSearctList ${mode==2?'fw-semibold text-primary':'' }" data-mode="2"> 답변완료 </button>
	            		<button type="button" class="btn btnSearctList ${mode==3?'fw-semibold text-primary':'' }" data-mode="3"> 미답변 </button>
	            	</div>
	            </div>
	            <div class="col-auto pt-2">
	            	<span>${dataCount}개(${page}/${total_page} 페이지)</span>
	            </div>
	        </div>
			
			<table class="table table-borderless board-list">
				<thead class="table-light">
					<tr class="border-bottom1">
						<th width="100">답변상태</th>
						<th>내용</th>
						<th width="100">작성자</th>
						<th width="100">작성일</th>
					</tr>
				</thead>
				
				<tbody>
					<c:forEach var="dto" items="${list}" varStatus="status">
						<tr class="item-basic-content border-bottom">
							<td>
								${not empty dto.answer ? '<span class="text-primary">답변완료</span>' : '<span class="text-secondary">답변대기</span>'}
							</td>
							<td class="left ellipsis">
								<span>${fn:replace(dto.review, "<br>", "")}</span>
							</td>
							<td>${dto.userName}</td>
							<td>${fn:substring(dto.review_date, 0, 10)}</td>
						</tr>
						<tr class="item-detail-content">
							<td colspan="6" class="left p-0">
								<div class="border-bottom p-2 px-3">
									<div class="bg-light p-2">
										<div>
											<div class="p-2 pb-0 fw-semibold">
												${dto.productName}(${dto.optionValue}/${dto.optionValue2})
											</div>
											
											<div class="row p-2">
												<div class="col-auto pt-0 ps-2 pe-1 score-star">
													<c:forEach var="n" begin="1" end="5">
														<span class="item fs-6 ${dto.score>=n ? 'on' : ''}"><i class="bi bi-star-fill"></i></span>
													</c:forEach>
												</div>
												<div class="col text-end">
													<span>${dto.review_date}</span>
													|<span class="deleteReview" data-num="${dto.num}">삭제</span>
													|<span class="answerReview" data-num="${dto.num}" data-showReview="${dto.showReview}">답변</span>
												</div>
											</div>
											
											<div class="p-2">${dto.review}</div>
											
											<c:if test="${not empty dto.listFilename}">
												<div class="row gx-1 mt-2 mb-1 p-1">
													<c:forEach var="filename" items="${dto.listFilename}">
														<div class="col-md-auto md-img">
															<img class="border rounded" src="${pageContext.request.contextPath}/uploads/review/${filename}">
														</div>
													</c:forEach>
												</div>
											</c:if>
											
										</div>
										
										<c:if test="${not empty dto.answer}">
											<div class="p-2 pt-0 border-top">
												<div class="bg-light">
													<div class="p-3 pb-0">
														<label class="text-bg-primary px-2"> 관리자 </label> <label>${dto.answer_date}</label>
													</div>
													<div class="p-3 pt-1 pb-1 answer-content">${dto.answer}</div>
												</div>
											</div>						
										</c:if>
										
									</div>
								</div>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			
			<div class="page-navigation">
				${dataCount == 0 ? "등록된 게시물이 없습니다." : paging}
			</div>

		</div>
	</div>
</div>

<div class="modal fade" id="answerDialogModal" tabindex="-1" 
		data-bs-backdrop="static" data-bs-keyboard="false"
		aria-labelledby="answerDialogModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="answerDialogModalLabel">리뷰 답변</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<div class="p-2 answer-form">
					<form name="answerForm" method="post">
						<div class="row">
							<div class="col">
								<span class="fw-bold">답변 달기</span>
							</div>
							<div class="col-3 text-end">
								<input type="checkbox" name="showReview" id="showReview1" class="form-check-input" 
									value="1">
								<label class="form-check-label" for="showReview1">표시</label>
							</div>
						</div>
						<div class="p-1">
							<input type="hidden" name="num">
							<input type="hidden" name="mode" value="${mode}">
							<input type="hidden" name="page" value="${page}">
							<textarea name="answer" id="answer" class="form-control"></textarea>
						</div>
					</form>
				</div>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary btnAnswerSendOk">답변등록 <i class="bi bi-check2"></i> </button>
				<button type="button" class="btn btn-secondary btnAnswerSendCancel" data-bs-dismiss="modal">취소</button>
			</div>			
		</div>
	</div>
</div>

<script type="text/javascript">
$('.answerReview').click(function(){
	let num = $(this).attr("data-num");
	let showReview = $(this).attr("data-showReview");
	let $answer = $(this).closest("td").find(".answer-content");
	let answer = "";
	if($answer.length) {
		answer = $answer.text();
	}
	
	const f = document.answerForm;
	f.num.value = num;
	if(showReview === "1") {
		f.showReview.checked = true;
	}
	f.answer.value = answer;
	
	$("#answerDialogModal").modal("show");
});

$('.btnAnswerSendOk').click(function(){
	const f = document.answerForm;
	let s;
	
	s = f.answer.value.trim();
	if( ! s ) {
		alert("답변을 입력하세요.")	;
		f.answer.focus();
		return false;
	}
	
	f.action = "${pageContext.request.contextPath}/admin/customer/review/answer";
	f.submit();
});

$('.btnAnswerSendCancel').click(function(){
	const f = document.answerForm;
	f.reset();
	
	$("#answerDialogModal").modal("hide");
});	
</script>
