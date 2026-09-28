<% String errorMessage = (String) request.getAttribute("error_message"); %>

<% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
    <div class="alert alert-danger alert-dismissible fade show my-3 shadow-sm" role="alert">
        <i class="fa-solid fa-circle-exclamation me-2"></i>
        <strong>Error:</strong> <%= errorMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
<% } %>
