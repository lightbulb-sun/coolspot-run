ADDRESS_SPEED_1         = $07763e
ADDRESS_SPEED_2         = $077672
ADDRESS_SPEED_3         = $0776c0
ANIMATION_POINTER       = $ff07b0
CHECK_FOR_RUN_BUTTON    = $0d3e56
MOVING_DIRECTION        = $fff51a
CURRENT_SPEED           = $fff4fe

LAST_A_PRESS_FLAG       = $ffff00
CUR_A_PRESS_FLAG        = $ffff01

NEW_OPTIONS_MENU        = $0ff400


    org 0
    incbin "coolspot.md"

    ; update run button
    org $d4c57
            db          $09

    ; point to new options menu which adds run button to triggers
    org $0d48e0
            lea         (NEW_OPTIONS_MENU).l, a0

    org $0cb5f4
            jsr         my_code
            nop

    org ADDRESS_SPEED_2
            ; loop back to walking speed
            ; instead of ramping up to moderate speed
            dw          $df00
            dl          ADDRESS_SPEED_1

    org $cc748
            ; start moving right
            jsr         start_moving
            nop
            nop
    org $cc83c
            ; start moving left
            jsr         start_moving
            nop
            nop


    org $0ff500
my_code:
            jsr         a_press
            ; replace original instructions
            jsr         $0cc676
            jmp         $0cbf8c

a_press:
.save_last_a_press_flag
            move.b      (CUR_A_PRESS_FLAG).l, d0
            move.b      d0, (LAST_A_PRESS_FLAG).l
.save_new_a_press_flag
            clr.b       (CUR_A_PRESS_FLAG).l
            jsr         CHECK_FOR_RUN_BUTTON
            seq         (CUR_A_PRESS_FLAG).l
.are_we_moving
            cmpi.b      #0, (MOVING_DIRECTION).l
            beq         .return
.do_we_have_a_difference
            cmp.b       (CUR_A_PRESS_FLAG).l, d0
            beq.b       .return
.do_we_have_a_new_a_press
            cmp.b       #0, d0
            bne.b       .have_stopped_pressing_a
.have_new_a_press
            jmp         set_speed3
.have_stopped_pressing_a
            jmp         set_speed1
.return
            rts

set_speed1:
            move.w      #1, (CURRENT_SPEED).l
            move.l      #ADDRESS_SPEED_1, (ANIMATION_POINTER).l
            rts

set_speed3:
            move.l      #ADDRESS_SPEED_3, (ANIMATION_POINTER).l
            rts

start_moving:
.are_we_holding_a
            move.b      (CUR_A_PRESS_FLAG), d0
            beq.b       set_speed1
            bra         set_speed3
