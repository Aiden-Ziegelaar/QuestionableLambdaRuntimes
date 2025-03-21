PROGRAM Handler
    IMPLICIT NONE
    INTEGER :: argc

    CHARACTER (LEN=100) :: input_source 
    CHARACTER (LEN=100) :: input_target

    CALL GET_COMMAND_ARGUMENT(1, input_source)

    CALL GET_COMMAND_ARGUMENT(2, input_target)

    PRINT *, edit_distance(input_source, input_target)
    
    contains

    pure elemental integer function edit_distance (source,target)
    character(len=*), intent(in) :: source, target
    integer                      :: len_source, len_target, i, j, cost
    integer                      :: matrix(0:len_trim(source), 0:len_trim(target))
       len_source = len_trim(source)
       len_target = len_trim(target)
       matrix(:,0) = [(i,i=0,len_source)]
       matrix(0,:) = [(j,j=0,len_target)]
       do i = 1, len_source
          do j = 1, len_target
             cost=merge(0,1,source(i:i)==target(j:j))
             matrix(i,j) = min(matrix(i-1,j)+1, matrix(i,j-1)+1, matrix(i-1,j-1)+cost)
          enddo
       enddo
       edit_distance = matrix(len_source,len_target)
    end function edit_distance
    
END PROGRAM Handler