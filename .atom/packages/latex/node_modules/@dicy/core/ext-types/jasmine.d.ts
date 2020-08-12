declare namespace jasmine {
  interface ArrayLikeMatchers<T> {
    toReceiveMessages(expected: any): boolean;
  }

  function arrayWithExactContents(sample: any[]): Expected<ArrayLike<string>>;
}
