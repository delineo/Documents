/* �Ͽ������ذ��� */

-- �Ͽ������� �з� �ڵ� ���
select * from TB_PL_SSTD_M
 where COMPANY_CD  = 'DEVW'
   and BSNS_TYPE_CD= 'PLV'
;

-- COMPVPAYCD              ȸ�纰 �Ͽ��� �޿�����
-- CRTE_EMPNO	           �Ͽ��� ��� ä�� ���� ��ȣ
-- LNG_RCUP_SBTREXEM_RATE  ����簨�����
-- VEARN_INCM_SET          �ٷμҵ�Ű�����ڷ����
-- VEMPATTDST              ���¿�����ؼ�������

select * from TB_PL_SSTD_D 
 where COMPANY_CD  = 'DEVW' 
   and BSNS_STD_CD = 'COMPVPAYCD'
;

select * from TB_CM_CODE_VALUE
 where COMPANY_CD  = 'DEVW'
   and CLASS_CD    = 'PLS_BSNS_TYPE_CD'
;

select * from TB_CM_CODE_VALUE
 where COMPANY_CD  = 'DEVW'
   and CLASS_CD    = 'PLS_UNIT_CD'
;