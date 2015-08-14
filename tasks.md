1. (Done) Basic architecture
1. (Done) Make new retro
1. (Done) List retros (landing)
1. (Done) Make new project
1. (Done) List projects (landing)
1. (Done) Add retro item
1. (Done) Edit/delete retro item
1. (Done) Styling project to item
   - change item successfully created/edited to original page with toast
   - list retros in reverse date order
1. (Done) Users and Owners
1. (Done) Authorization
1. (Done) TESTS!!!!
1. (Done) MORE TESTS!!!
1. (Done) Limit creating duplicates
1. Review workflow
   - retro states: 
   		new - nothing, waiting to add
   		(done) adding_issues - users may add/edit/remove issues
   		(done) in_review - discuss each item (time limit), L->R, T->B
   		(done) voting - users add/remove up to three points per retro, signal "done"
   		(done) voted_review - ordered by highest - lowest points
   		complete - review is done
   - (done) start review (owner) (with navigation, overlay, show timer)
   - (done) open for pointing
   - (done) close pointing (owner)
   - (done) pointed review (owner)
   - (done) generate task from review
   - (done) close retro
   - feature specs to test
1. (done) Show retro's outstanding tasks
1. (done) Close retro's outstanding tasks
1. Nag task targets
1. (done) Pick retro icons

REMAINING ISSUES:
1. Workflow for creating and interacting with projects is weird and flawed. This isn't gonna be relevant much since projects are only rarely modified, but
   I may go back and fix it at some point. 
2. There is currently no way to edit user attributes (updating your password fails)
3. inputs for project/issue/task descriptions aren't sanitized until they hit the server, so people can still be trolled by it.
