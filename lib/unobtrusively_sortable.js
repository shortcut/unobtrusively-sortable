(function($){
	$.unobtrusivelySortable = function(options){
		var settings = $.extend({
			axis: "y",
			update: function(){
				var authenticityToken = encodeURIComponent($(this).find("input[name=authenticity_token]").val())
				$.ajax({
					type: "POST",
					url: $(this).attr("sort_url"),
					data: ($(this).sortable('serialize') + "&authenticity_token=" + authenticityToken)
				})
			}
		}, options)
		
		$('.unobtrusively_sortable_list form.button-to').hide()
		$('.unobtrusively_sortable_list').sortable(settings)
	}
})(jQuery)