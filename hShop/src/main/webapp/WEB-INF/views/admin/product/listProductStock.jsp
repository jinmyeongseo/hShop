<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div>
	<div class="mt-3">
		<div class="p-3 shadow bg-body rounded">
			<p class="fs-6 fw-semibold mb-0">${productName}</p> 
		</div>
		<div class="mt-3 p-2">
			<div class="row pb-2">
				<div class="col text-end">
					<button type="button" class="btn btn-light border btn-allStockUpdate"
						data-productNum="${productNum}">일괄등록</button>
				</div>
			</div>
			<table class="table table-border table-list">
				<thead>
					<tr class="border-top border-dark table-light">
						<th width="100">번호</th>
						<th class="left" width="200">${title}</th>
						<th class="left" width="200">${title2}</th>
						<th width="170">재고량</th>
						<th>변 경</th>
					</tr>
				</thead>
				<tbody class="productStcok-list">
					<c:if test="${list.size() == 0}">
						<tr>
							<td colspan="5">등록된 상품이 없습니다.</td>
						</tr>
					</c:if>
					<c:if test="${list.size() != 0}">
						<c:forEach var="dto" items="${list}" varStatus="status">
							<tr valign="middle">
								<td>${status.count}</td>
								<td class="left">${dto.optionValue}</td>
								<td class="left">${dto.optionValue2}</td>
								<td class="left">
									<input type="text" name="totalStock" class="form-control" value="${dto.totalStock}">
								</td>
								<td>
									<button type="button" class="btn border btn-light btn-stockUpdate"
										data-stockNum="${dto.stockNum}"
										data-detailNum="${dto.detailNum}"
										data-detailNum2="${dto.detailNum2}"
										data-productNum="${dto.productNum}">등록</button>
								</td>
							</tr>
						</c:forEach>
					</c:if>
				</tbody>
			</table>
		
		</div>
	</div>
</div>
