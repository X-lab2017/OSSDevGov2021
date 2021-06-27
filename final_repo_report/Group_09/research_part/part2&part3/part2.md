# 开发者参与流程调研
vue开源项目共有328个issue，202个Pull requests。开发者参与vue项目需要遵循一定的流程。vue项目在CONTRIBUTING.md中说明了要遵循的准则。
## Issue Reporting Guidelines
需要始终使用https://new-issue.vuejs.org/ 来创建新的issue
## Pull Request Guidlines
所有的开发工作都应在专门的分支中进行，不要提交对主分支的PR。主分支只是最新稳定版的一个快照。
从相关的分支中check出一个主题分支，并对该分支进行合并。
在 src 文件夹中工作，不要在提交中check in dist
开发者在PR上工作时，可以有多个小的提交 ，GitHub会在合并前自动整合。
确保npm测试通过。
如果增加一个新的功能。需要添加相应的测试案例。
提供一个令人信服的理由来添加这个功能。理想情况下，开发者应该先打开一个建议问题，并在工作前得到批准。
如果修复错误。如果你正在解决一个专门的问题，在你的PR标题中添加（fix #xxxx[,#xxxx]）（#xxxx是问题ID），在PR中提供详细的问题描述。并添加适当的测试范围。
## Development Setup
开发者的开发环境需要Node.js版本8以上，Java运行时环境（用于在e2e测试中运行Selenium服务器）和yarn。克隆完仓库后，运行。并安装项目所需依赖项。
## Committing Changes
提交信息应遵循提交信息惯例，以便自动生成更新日志。提交信息在提交时将被自动验证。如果你不熟悉提交信息惯例，你可以用npm run commit代替git commit，它提供了一个交互式CLI来生成正确的提交信息。
## Commonly used NPM scrpits
自动构建dist/vue.js $npm run dev
构建所有的dist files，包括npm packages $npm run build
运行整个test suite,包括linting/type checking $npm test
在package.json文件的scripts部分还有一些其他脚本。

默认的测试脚本将进行以下工作：用ESLint进行lint -> 用Flow进行类型检查 -> 用coverage进行单元测试 -> e2e测试。请确保在提交PR之前成功通过这个测试。虽然同样的测试会在CI服务器上针对你的PR运行，但最好在本地运行。

## Project Structure
### scripts: 
包含与构建相关的脚本和配置文件。通常情况下，你不需要去碰它们。然而，熟悉以下文件会很有帮助。
#### scripts/alias.js：
所有源代码和测试中使用的模块导入别名。
#### scripts/config.js：
包含在dist/中找到的所有文件的构建配置。如果你想找出某个dist文件的入口源文件，请查看这个文件。
### dist：
包含用于发布的构建文件。注意这个目录只有在发布时才会更新；它们并不反映开发分支的最新变化。关于dist文件的更多细节，见dist/README.md。
### flow: 
包含Flow的类型声明。这些声明是全局加载的，你会看到它们在正常源代码的类型注释中被使用。
### packages: 
包含vue-server-renderer和vue-template-compiler，它们作为独立的NPM包发布。它们从源代码中自动生成，并且总是与主vue包有相同的版本。
### test：
包含所有测试。单元测试是用Jasmine编写的，用Karma运行。e2e测试是为Nightwatch.js编写并运行的。
### src：
包含源代码。该代码库是用ES2015编写的，带有Flow类型注释。
#### compiler：
包含模板到渲染函数编译器的代码。编译器包括一个解析器（将模板字符串转换为元素AST）、一个优化器（检测静态树以进行vdom渲染优化）和一个代码生成器（从元素AST生成渲染函数代码）。请注意，codegen直接从元素AST中生成代码字符串--这样做是为了减小代码的大小，因为编译器是在独立构建中运送给浏览器的。
#### core: 
contains universal, platform-agnostic runtime code.The Vue 2.0 core is platform-agnostic. That is, the code inside core is able to be run in any JavaScript environment, be it the browser, Node.js, or an embedded JavaScript runtime in native applications.
#### server：
包含与服务器端渲染有关的代码。
#### platforms：
包含特定平台的代码。dist构建的入口文件位于各自的平台目录中。每个平台模块包含三个部分：编译器、运行时和服务器，对应于上述三个目录。每个部分都包含平台特定的模块/工具，它们被导入并注入到平台特定的入口文件中的核心对应部分。例如，实现v-bind:class背后的逻辑的代码在pl platforms/web/runtime/modules/class.js中--它被导入到 entries/web-runtime.js中，用于创建浏览器特定的vdom补丁功能。
#### sfc：
包含单文件组件（*.vue文件）的解析逻辑。这在vue-template-compiler包中使用。
#### shared:
 包含在整个代码库中共享的实用程序。
#### types:
包含TypeScript类型定义
## Financial Contribution
作为一个纯社区驱动的项目，没有大公司的支持，VUE也欢迎通过Patreon和OpenCollective进行财务捐助。
### 成为Patreon上的支持者或赞助者
### 在OpenCollective上成为支持者或赞助者
### 通过PayPal或加密货币进行一次性捐赠
通过Patreon捐赠的资金直接用于支持Evan You在Vue.js的全职工作。通过OpenCollective捐赠的资金在管理上是透明的，将用于补偿核心团队成员的工作和费用或赞助社区活动。通过在这两个平台上的捐赠，你的名字/logo将得到适当的认可和曝光。



