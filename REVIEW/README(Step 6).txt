🧠 Step 6: 내 정보 & 하단 탭바 완벽 통합 복기


오늘 마지막으로 장식한 Step 6의 핵심 기술 포인트 정리 들어간다! 
이것도 면접이나 포트폴리오에 쓰기 딱 좋은 내용이야.


1. "구글아, 내 정보 좀 줘!" - Firebase Auth 연동
> 핵심 개념
  FirebaseAuth.instance.currentUser

> 원리: 우리가 Step 1에서 구글 로그인을 성공시켜 놨기 때문에, 
  Firebase가 앱 전체에 '지금 로그인한 사람의 신분증'을 들고 다녀. 
  그래서 마이페이지에서 이 코드 한 줄만 쓰면 
  프사(photoURL), 이름(displayName), 이메일(email)을 공짜로 쫙 뽑아올 수 있었어.



2. "안전하게 방 빼기" - 로그아웃과 라우팅
> 핵심 로직
  FirebaseAuth.instance.signOut() + Navigator.pushReplacement

> 원리
  로그아웃 처리를 서버에 확실히 알려주고, 
  가장 중요한 건 pushReplacement를 써서 탭바가 있던 메인 화면을 완전히 '파괴'하고 쫓아냈다는 거야. 
  이거 안 쓰면 로그아웃했는데 안드로이드 폰에서 [뒤로 가기] 눌렀을 때 
  다시 로그인된 화면으로 들어가는 대참사가 발생하거든! ㅋㅋㅋ



3. "앱의 척추 완성" - BottomNavigationBar 통합
> 원리
  뿔뿔이 흩어져 있던 StudyListScreen(홈), 
  ChatListScreen(채팅), 
  MyPageScreen(내 정보)을
  MainScreen이라는 하나의 큰 통발(Scaffold)에 넣고 
  버튼을 누를 때마다 화면만 슉슉 갈아 끼워주는 구조를 완성했어!