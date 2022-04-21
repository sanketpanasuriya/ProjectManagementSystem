module ProjectsHelper
    
    def getAlertLabel(day_left, isCompleted)
        if isCompleted
            "<div class='label  badge badge-success rounded'>Completed</div>"
        elsif day_left < 8 && day_left > 0
            "<div class='label bg-info rounded text-white'>day left <span class='lable badge badge-danger rounded-circle mb-1'>#{day_left.to_i}</span></div>"
        elsif day_left == 0
            "<div class='label bg-danger rounded text-white'>Need to Complete Today</div>"
        elsif day_left < 0
            "<div class='label bg-info rounded text-white'>Overdue by <span class='lable badge badge-danger rounded-circle mb-1'>#{day_left.to_i.abs}</span> days</div>"
        end
    end
end