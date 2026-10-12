const notes = [
  { id: 1, title: "회의 메모", body: "다음 주 배포 일정 확인" },
  { id: 2, title: "배포 체크리스트", body: "캐시 무효화, 로그 확인" },
];

module.exports = {
  all: () => notes,
  get: (id) => notes.find((n) => n.id === id),
};
