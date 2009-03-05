(function($){
	$.unobtrusivelySortable = function(options){
		var settings = $.extend({
			handle: $('<span class="handle"></span>')
		}, options)
		
		$('.unobtrusively_sortable_list form.button-to').hide()
		$('.unobtrusively_sortable_list li').prepend(settings["handle"])
		$('.unobtrusively_sortable_list').sortable({
			update: function(){
				var authenticityToken = encodeURIComponent($(this).find("input[name=authenticity_token]").val())
				$.ajax({
					type: "POST",
					url: $(this).attr("sort_url"),
					data: ($(this).sortable('serialize') + "&authenticity_token=" + authenticityToken)
				})
			}
		})
	}
})(jQuery)