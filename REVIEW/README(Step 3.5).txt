🏗️ Step 3.5: Firestore 데이터 삭제 기능 복기

1. 주요 코드 및 로직 정리

study_list_screen.dart - ID 배달부
서버에서 가져온 doc.id를 StudyCard와 상세 페이지로 안전하게 전달함.

study_detail_screen.dart - 실행자
전달받은 docId를 사용해 서버에 "이 데이터를 지워줘!"라고 요청함.

_deleteStudy 함수 - 안전장치
showDialog를 통해 실수로 지우는 것을 방지하고, 성공 시 화면을 닫음.



2. 핵심 로직 흐름 (The Logic Flow)
삭제 기능은 "주소"를 찾는 과정이 제일 중요해:

1) ID 획득: Firestore의 각 문서(Document)는 고유한 docId를 가지고 있어. 
           리스트 화면에서 이 ID를 미리 챙겨둬야 해.

2) ID 전달: StudyCard를 거쳐 StudyDetailScreen으로 
           이 ID를 파라미터로 넘겨줘. (이때 우리가 생성자 에러를 고쳤었지!)

3) 삭제 요청: FirebaseFirestore.instance.collection('studies').doc(docId).delete() 명령어를 실행해.

4) 실시간 반영: 서버에서 데이터가 지워지면, 
              리스트 화면의 StreamBuilder가 이를 감지하고 
              화면에서 해당 항목을 즉시 제거해.



3. 우리가 해결한 '진짜' 공부 포인트 (War Stories)

1) 생성자(Constructor) 정렬
StudyDetailScreen이 docId를 요구하도록 바꿨다면, 
> 이를 호출하는 StudyCard와 리스트 화면에서도 똑같이 맞춰줘야 한다는 
  '데이터 흐름의 일관성'을 배웠어.

2) 비동기 처리와 Context
> 서버 통신은 시간이 걸리는 작업(await)이므로, 
  작업이 끝난 뒤 화면을 닫을 때 context.mounted를 체크하는 디테일까지 챙겼지!

3) 확인 창(Dialog) 구현
> 중요한 기능에는 반드시 사용자의 의사를 한 번 더 묻는 UI가 필요하다는 걸 익혔어.
           