🏗️ Step 3: Cloud Firestore 실시간 연동 복기

1. 주요 파일별 핵심 역할파일명핵심 코드 & 기능설명
study_create_screen.dartcollection('studies').add({...})사용자가 입력한 제목, 내용, 태그를 
Firestore 서버의 'studies' 폴더에 저장.

study_list_screen.dartStreamBuilder, snapshots()서버를 실시간으로 감시하다가 데이터가 바뀌면 화면을 즉시 새로고침.

study_detail_screen.dartfinal Map<String, dynamic> data리스트에서 선택한 특정 게시글의 정보를 넘겨받아 화면에 출력.


2. 핵심 로직 흐름 (Data Flow)
우리가 구현한 데이터의 여행 경로는 다음과 같아

1) 입력 (Create): TextEditingController로 사용자의 글을 읽어서 add() 함수로 서버에 쏜다!

2) 동기화 (Sync): Firestore 서버에 데이터가 도착하는 순간, 
   구글 서버가 우리 앱의 StreamBuilder에게 "데이터 바뀌었어!"라고 신호를 보낸다.

3) 출력 (Read): 리스트 화면이 신호를 받자마자 새 글을 포함해서 화면을 다시 그린다.

4) 전달 (Pass): 리스트의 카드를 누르면, 해당 카드의 Map 데이터를 상세 화면의 생성자(Constructor)로 던져준다.



3. 우리가 겪은 난관과 해결책 (Troubleshooting)

StatefulWidget의 필요성
> 처음에 Stateless였던 화면을 Stateful로 바꾸면서 Controller를 통해 입력값을 가져올 수 있게 됐어.

괄호 ()의 습격
> MaterialPageRoute 뒤에 괄호를 빠뜨려서 생긴 에러를 직접 찾아서 해결했지. (이게 진짜 실력이 늘어나는 순간이야!)

보안 규칙(Rules)
> 'Permission Denied' 에러가 나지 않도록 테스트 모드 설정을 확인하는 법을 배웠어.