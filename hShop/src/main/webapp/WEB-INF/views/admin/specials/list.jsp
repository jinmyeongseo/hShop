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

.table-list { width: 100%; }
.table-list thead { color: #787878; }
.table-list tr>th { padding-top: 10px; padding-bottom: 10px; }
.table-list tr>th, .table-list tr>td { text-align: center; }
.table-list .left { text-align: left; padding-left: 5px; }
</style>

<script type="text/javascript">
function searchList() {
	const f = document.searchForm;
	f.submit();
}

// 탭
$(function(){
	$("button[role='tab']").on('click', function(){
		const tab = $(this).attr("aria-controls");
		
		let url = "${pageContext.request.contextPath}/admin/specials/${classify}/main";
		if(tab !== "1") {
			url += "?state=" + tab;
		}
		location.href = url;
	});
});
</script>

<div class="container">
	<div class="body-container">
		<div class="body-title">
			<h3><i class="bi bi-app"></i> ${classify==200 ? "오늘의 특가" : "기획전" } </h3>
		</div>
		
		<div class="body-main">
			<ul class="nav nav-tabs mt-5" id="myTab" role="tablist">
				<li class="nav-item" role="presentation">
					<button class="nav-link ${state==1?'active':''}" id="tab-1" data-bs-toggle="tab" data-bs-target="#tab-pane" type="button" role="tab" aria-controls="1" aria-selected="${state==1?'true':'false'}">진행중</button>
				</li>
				<li class="nav-item" role="presentation">
					<button class="nav-link ${state==2?'active':''}" id="tab-2" data-bs-toggle="tab" data-bs-target="#tab-pane" type="button" role="tab" aria-controls="2" aria-selected="${state==2?'true':'false'}">진행예정</button>
				</li>
				<li class="nav-item" role="presentation">
					<button class="nav-link ${state==3?'active':''}" id="tab-3" data-bs-toggle="tab" data-bs-target="#tab-pane" type="button" role="tab" aria-controls="3" aria-selected="${state==3?'true':'false'}">기간종료</button>
				</li>
			</ul>
			
			<div class="tab-content pt-4" id="myTabContent">
				<div class="tab-pane fade show active" id="tab-pane" role="tabpanel" aria-labelledby="tab-1" tabindex="0">
					<div class="row mb-2">
						<div class="col">
							<div class="row text-end">
								<div class="col-auto pe-1">
									&nbsp;
								</div>
							</div>
						</div>
						<div class="col-auto pt-2 text-end">
							${dataCount}개(${page}/${total_page} 페이지)
						</div>
					</div>
					
					<table class="table table-border table-list">
						<thead>
							<tr class="border-top border-dark table-light">
								<th width="60">번호</th>
								<th>제목</th>
								<th width="130">시작일자</th>
								<th width="130">종료일자</th>
								<th width="70">상품수</th>
								<th width="60">출력</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="dto" items="${list}" varStatus="status">
								<tr valign="middle">
									<td>${dataCount - (page-1) * size - status.index}</td>
									<td class="left">
										<a href="${articleUrl}&specialNum=${dto.specialNum}">${dto.subject}</a>
									</td>
									<td>${dto.startDate}</td>
									<td>${dto.endDate}</td>
									<td>${dto.productCount}</td>
									<td>${dto.showSpecial==1?"표시":"숨김"}</td>
								</tr>					
							</c:forEach>
						</tbody>
					</table>
		
					<div class="page-navigation">
						${dataCount == 0 ? "등록된 정보가 없습니다." : paging}
					</div>
					
					<table class="table table-borderless">
						<tr>
							<td width="150">
								<button type="button" class="btn btn-light" onclick="location.href='${pageContext.request.contextPath}/admin/specials/${classify}/main';"> <i class="bi bi-arrow-clockwise"></i> </button>				
							</td>
							<td align="center">
								<form class="row justify-content-center" name="searchForm" action="${pageContext.request.contextPath}/admin/specials/${classify}/main" method="post">
									<div class="col-auto p-1">
										<select name="schType" class="form-select">
											<option value="all" ${schType=="all"?"selected":""}>제목+내용</option>
											<option value="subject" ${schType=="subject"?"selected":""}>제목</option>
											<option value="content" ${schType=="content"?"selected":""}>내용</option>
										</select>
									</div>
									<div class="col-auto p-1">
										<input type="text" name="kwd" value="${kwd}" class="form-control">
									</div>
									<div class="col-auto p-1">
										<input type="hidden" name="state" value="${state}">
										<button type="button" class="btn btn-light" onclick="searchList()"> <i class="bi bi-search"></i> </button>
									</div>
								</form>
							</td>					
							<td width="150" align="right">
								<button type="button" class="btn btn-light" onclick="location.href='${pageContext.request.contextPath}/admin/specials/${classify}/write';">등록하기</button>
							</td>
						</tr>
					</table>
				
				</div>
			</div>  <!-- tab-content _ end -->

		</div> <!-- body-main -->
	</div>
</div>
