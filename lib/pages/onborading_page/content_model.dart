class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent({
    required this.image,
    required this.title,
    required this.discription,
  });
}

List<UnbordingContent> contents = [
  UnbordingContent(
    title: 'Quality of service',
    image: 'assets/onboarding/ticket.png',
    discription:
        "simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the "
        "industry's standard dummy text ever since the 1500s, "
        "when an unknown printer took a galley of type and scrambled it ",
  ),
  UnbordingContent(
    title: 'Fast Delevery',
    image: 'assets/onboarding/ticket2.png',
    discription:
        "simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the "
        "industry's standard dummy text ever since the 1500s, "
        "when an unknown printer took a galley of type and scrambled it ",
  ),
  UnbordingContent(
    title: 'Reward surprises',
    image: 'assets/onboarding/ticket3.png',
    discription:
        "simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the "
        "industry's standard dummy text ever since the 1500s, "
        "when an unknown printer took a galley of type and scrambled it ",
  ),
];
