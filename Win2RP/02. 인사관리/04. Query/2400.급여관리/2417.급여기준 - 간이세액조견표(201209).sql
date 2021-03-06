select
        A.COMPANY_CD                    /* 회사코드             */
     ,  A.EFF_START_DT                  /* 유효시작일           */
     ,  A.EFF_END_DT                    /* 유효종료일           */
     ,  A.PAY_MON_UNDER                 /* 월급여액-미만        */
     ,  A.PAY_MON_OVER                  /* 월급여액-이상        */
     ,  A.FMLY_OBJ1_CNT                 /* 공제대상 가족의 수1  */
     ,  A.FMLY_OBJ2_CNT                 /* 공제대상 가족의 수2  */
     ,  A.FMLY_OBJ3_CNT                 /* 공제대상 가족의 수3  */
     ,  A.FMLY_OBJ4_CNT                 /* 공제대상 가족의 수4  */
     ,  A.FMLY_OBJ5_CNT                 /* 공제대상 가족의 수5  */
     ,  A.FMLY_OBJ6_CNT                 /* 공제대상 가족의 수6  */
     ,  A.FMLY_OBJ7_CNT                 /* 공제대상 가족의 수7  */
     ,  A.FMLY_OBJ8_CNT                 /* 공제대상 가족의 수8  */
     ,  A.FMLY_OBJ9_CNT                 /* 공제대상 가족의 수9  */
     ,  A.FMLY_OBJ10_CNT                /* 공제대상 가족의 수10 */
     ,  A.FMLY_OBJ11_CNT                /* 공제대상 가족의 수11 */

  from TB_PL_SSIMPTAX_D A
 where A.COMPANY_CD = 'DEVW'
 order by A.PAY_MON_UNDER